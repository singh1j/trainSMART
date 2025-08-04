//
//  DetailedStatsView.swift
//  trainSMART
//
//  Created by Jugad Singh on 1/1/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct DetailedStatsScreen: View {
    @State var goBack = false
    @State private var dayGoal: String = ""
    @State private var hourGoal: String = ""
    @State private var totalDays: String = ""
    @State private var totalHours: String = ""
    @State private var daysThisWeek: String = ""
    @State private var hoursThisWeek: String = ""
    @State private var showingGoalEditor = false
    func fetchLifetimeStats(completion: @escaping (_ totalDays: String, _ totalHours: String) -> Void) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            completion("0", "0")
            return
        }

        userDB.document(userEmail).getDocument { document, error in
            guard let data = document?.data(), error == nil else {
                completion("0", "0")
                return
            }

            let days = data["total-days"] as? Int ?? 0
            let hours = data["total-hours"] as? Double ?? 0.0

            let formattedDays = "\(days)"
            let formattedHours = String(format: "%.1f", hours)

            completion(formattedDays, formattedHours)
        }
    }
    func fetchWeeklyGoals(completion: @escaping (_ dayGoal: String, _ hourGoal: String) -> Void) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            completion("0", "0.0")
            return
        }

        userDB.document(userEmail).getDocument { document, error in
            guard let data = document?.data(), error == nil else {
                completion("0", "0.0")
                return
            }

            let days = data["day-goal"] as? Int ?? 0
            let hours = data["hour-goal"] as? Double ?? 0.0

            let formattedDays = "\(days)"
            let formattedHours = String(format: "%.1f", hours)

            completion(formattedDays, formattedHours)
        }
    }
    func fetchThisWeekStats(completion: @escaping (_ daysThisWeek: String, _ hoursThisWeek: String) -> Void) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            completion("0", "0.0")
            return
        }

        userDB.document(userEmail).getDocument { document, error in
            guard let data = document?.data(), error == nil else {
                completion("0", "0.0")
                return
            }

            let days = data["days-this-week"] as? Int ?? 0
            let hours = data["hours-this-week"] as? Double ?? 0.0

            let formattedDays = "\(days)"
            let formattedHours = String(format: "%.1f", hours)

            completion(formattedDays, formattedHours)
        }
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Logo section
                    ZStack {
                        Color("Brand Color OffWhite")
                            .frame(height: 150)
                        Image("trainSMARTLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .padding(.top, 20)
                    }
                    .frame(height: 150)

                    ScrollView {
                        // Weekly Goals Section
                        VStack {
                            HStack {
                                Text("Your Weekly Goals")
                                    .font(.title3)
                                    .foregroundStyle(Color("Brand Color OffWhite"))
                                    .padding()
                                Spacer()
                                Button(action: {
                                    showingGoalEditor = true
                                }) {
                                    Text("Change Goals")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background(Color("Brand Color OffWhite"))
                                        .cornerRadius(12)
                                }
                                .padding(.trailing)
                                .sheet(isPresented: $showingGoalEditor) {
                                    EditGoalsSheet(
                                        isPresented: $showingGoalEditor,
                                        currentDayGoal: $dayGoal,
                                        currentHourGoal: $hourGoal
                                    )
                                }


                            }

                            HStack {
                                Spacer()
                                VStack {
                                    Text(dayGoal)
                                        .font(.title3)
                                        .foregroundColor(.black)
                                    Text("Days/Week")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 100, height: 100)
                                .background(Color("Brand Color OffWhite"))
                                .cornerRadius(13)
                                .padding()

                                Spacer()

                                VStack {
                                    Text(hourGoal)
                                        .font(.title3)
                                        .foregroundColor(.black)
                                    Text("Hours/Week")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 100, height: 100)
                                .background(Color("Brand Color OffWhite"))
                                .cornerRadius(13)
                                .padding()

                                Spacer()
                            }
                        }
                        .padding(.bottom)

                        // This Week Section
                        VStack {
                            HStack {
                                Text("This week...")
                                    .font(.title3)
                                    .foregroundStyle(Color("Brand Color OffWhite"))
                                    .padding()
                                Spacer()
                                Button(action: {
                                    goBack = true
                                }) {
                                    Text("Details")
                                        .font(.subheadline)
                                        .foregroundStyle(Color.black)
                                        .padding()
                                }
                                .background(Color("Brand Color OffWhite"))
                                .cornerRadius(15)
                                .padding()
                                .navigationDestination(isPresented: $goBack) {
                                    WeeklyScreen()
                                }
                            }

                            HStack {
                                Spacer()
                                VStack {
                                    Text("3") // Replace with dynamic value if desired
                                        .font(.title3)
                                        .foregroundColor(.black)
                                    Text("Days")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 100, height: 100)
                                .background(Color("Lavender"))
                                .cornerRadius(13)
                                .padding()

                                Spacer()

                                VStack {
                                    Text("3") // Replace with dynamic value if desired
                                        .font(.title3)
                                        .foregroundColor(.black)
                                    Text("Hours")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 100, height: 100)
                                .background(Color("Lavender"))
                                .cornerRadius(13)
                                .padding()

                                Spacer()
                            }
                        }
                        .padding(.bottom)

                        // Lifetime Stats Section
                        VStack {
                            HStack {
                                Text("Lifetime Stats...")
                                    .font(.title3)
                                    .foregroundStyle(Color("Brand Color OffWhite"))
                                    .padding()
                                Spacer()
                            }

                            HStack {
                                Spacer()
                                VStack {
                                    Text(totalDays)
                                        .font(.title3)
                                        .foregroundColor(.black)
                                    Text("Days")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 100, height: 100)
                                .background(Color("Brown"))
                                .cornerRadius(13)
                                .padding()

                                Spacer()

                                VStack {
                                    Text(totalHours)
                                        .font(.title3)
                                        .foregroundColor(.black)
                                    Text("Hours")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 100, height: 100)
                                .background(Color("Brown"))
                                .cornerRadius(13)
                                .padding()

                                Spacer()
                            }
                        }
                        .padding(.bottom)
                    }
                    .background(Color("Brand Color Blue"))
                }
                .background(Color("Brand Color Blue"))
            }
            .tint(Color("Dark blue"))
            .edgesIgnoringSafeArea(.top)
        }
        .onAppear {
            fetchWeeklyGoals { day, hour in
                self.dayGoal = day
                self.hourGoal = hour
            }

            fetchLifetimeStats { days, hours in
                self.totalDays = days
                self.totalHours = hours
            }

            fetchThisWeekStats { weekDays, weekHours in
                self.daysThisWeek = weekDays
                self.hoursThisWeek = weekHours
            }
        }


    }
}

#Preview {
    DetailedStatsScreen()
}
