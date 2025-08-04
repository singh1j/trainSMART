//
//  WeeklyView.swift
//  trainSMART
//
//  Created by Jugad Singh on 12/31/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct DayData: Identifiable {
    let id = UUID()
    let dayInitial: String
    let dayName: String
    let minutesSpent: Int
    let drills: Int
    let rating: Int
}
func getRating(_ minutes: Int, weeklyGoal: Int) -> Color {
    let dailyGoal = (weeklyGoal * 60) / 7  // Convert hours to minutes and divide by 7
    let percentage = Double(minutes) / Double(dailyGoal)
    
    if dailyGoal == 0 { return Color.gray }  // Handle case where goal isn't set
    
    switch percentage {
    case 0:
        return Color.red.opacity(0.7)
    case 0.5..<0.8:
        return Color.yellow.opacity(0.8)
    case 0.8...:
        return Color.green.opacity(0.8)
    default:
        return Color.red.opacity(0.7)
    }
}
func calculateRating(_ minutes: Int, weeklyGoal: Int) -> Int {
    guard weeklyGoal > 0 else { return 0 }

    let dailyGoal = (weeklyGoal * 60) / 7
    guard dailyGoal > 0 else { return 0 }

    let rawRating = Double(minutes) / Double(dailyGoal) * 5
    return min(5, max(0, Int(round(rawRating))))
}

struct WeeklyScreen: View {
    @State private var days: [DayData] = []
    @State var goToDetails = false
    @State private var weeklyGoal: Int = 0
    
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
                        VStack(spacing: 10) {
                            HStack {
                                Text("This week...")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color("Brand Color OffWhite"))
                                    .padding()
                                Spacer()
                                Button(action: {
                                    goToDetails = true
                                }) {
                                    Text("More")
                                        .font(.subheadline)
                                        .foregroundStyle(Color.black)
                                        .padding()
                                }
                                .background(Color("Brand Color OffWhite"))
                                .cornerRadius(15)
                                .padding(.trailing)
                                .navigationDestination(isPresented: $goToDetails) {
                                    DetailedStatsScreen()
                                }
                            }
                            .padding(.top)
                            
                            if days.isEmpty {
                                Text("Loading days...")
                                    .foregroundColor(.white)
                                    .padding()
                            } else {
                                ForEach(days) { day in
                                    DayRow(day: day, weeklyGoal: weeklyGoal)
                                }
                            }
                        }
                        .padding(.bottom, 20)
                    }
                    .background(Color("Brand Color Blue"))
                }
                .edgesIgnoringSafeArea(.top)
            }
        }
        .tint(Color("Dark blue"))
        .onAppear {
            print("🔄 View appeared")
            print("👤 Current user: \(String(describing: Auth.auth().currentUser))")
            print("📧 User email: \(String(describing: Auth.auth().currentUser?.email))")
            
            fetchDailyStats { fetchedDays in
                print("📱 Received \(fetchedDays.count) days")
                self.days = fetchedDays
            }
        }
    }
    
    // Move fetchDailyStats here
    func fetchDailyStats(completion: @escaping ([DayData]) -> Void) {
        if Auth.auth().currentUser == nil {
            print("⚠️ No user logged in")
            return
        }
        
        guard let userEmail = Auth.auth().currentUser?.email else {
            print("❌ No user email found for user: \(String(describing: Auth.auth().currentUser?.uid))")
            return
        }
        
        print("🔍 Starting fetch for user: \(userEmail)")
        
        // First fetch the weekly goal
        userDB.document(userEmail).getDocument { document, error in
            if let error = error {
                print("❌ Error fetching weekly goal: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                self.weeklyGoal = document.data()?["hour-goal"] as? Int ?? 0
                print("📊 Weekly goal fetched: \(self.weeklyGoal)")
            } else {
                print("⚠️ No user document found")
            }
            
            // Define the days of the week
            let daysOfWeek = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
            print("📅 Fetching data for days: \(daysOfWeek)")
            
            var dayStats: [DayData] = []
            let group = DispatchGroup()
            
            for day in daysOfWeek {
                group.enter()
                print("🔍 Fetching data for \(day)")
                
                let docRef = userDB
                    .document(userEmail)
                    .collection("daily")
                    .document(day)
                
                docRef.getDocument { document, error in
                    defer { 
                        group.leave()
                        print("✅ Finished processing \(day)")
                    }
                    
                    if let error = error {
                        print("❌ Error fetching \(day): \(error.localizedDescription)")
                        return
                    }
                    
                    // Get the day name and initial
                    let dayName = day.prefix(1).uppercased() + day.dropFirst()
                    let dayInitial = String(day.prefix(1).uppercased())
                    
                    if let document = document, document.exists,
                       let data = document.data() {
                        print("📝 Found data for \(day): \(data)")
                        
                        let minutes = data["minutes"] as? Int ?? 0
                        let drills = data["drills"] as? Int ?? 0
                        let rating = data["rating"] as? Int ?? 0
                        
                        dayStats.append(DayData(
                            dayInitial: dayInitial,
                            dayName: dayName,
                            minutesSpent: minutes,
                            drills: drills,
                            rating: rating
                        ))
                    } else {
                        print("ℹ️ No data for \(day), adding empty day")
                        dayStats.append(DayData(
                            dayInitial: dayInitial,
                            dayName: dayName,
                            minutesSpent: 0,
                            drills: 0,
                            rating: 0
                        ))
                    }
                }
            }
            
            group.notify(queue: .main) {
                print("🏁 All days processed. Stats count: \(dayStats.count)")
                
                let dayOrder = [
                    "Sunday": 0,
                    "Monday": 1,
                    "Tuesday": 2,
                    "Wednesday": 3,
                    "Thursday": 4,
                    "Friday": 5,
                    "Saturday": 6
                ]
                
                let sortedStats = dayStats.sorted { day1, day2 in
                    let order1 = dayOrder[day1.dayName] ?? 0
                    let order2 = dayOrder[day2.dayName] ?? 0
                    return order1 < order2
                }
                
                print("📊 Final sorted stats: \(sortedStats)")
                completion(sortedStats)
            }
        }
    }
}

struct DayRow: View {
    let day: DayData
    let weeklyGoal: Int
    
    var body: some View {
        HStack {
            VStack {
                Text(day.dayInitial)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(day.dayName)
                    .font(.caption)
                    .foregroundColor(.black)
            }
            .frame(width: 100, height: 70)
            .background(Color("Lavender"))
            .cornerRadius(13)
            
            Spacer()
            
            HStack {
                VStack {
                    Text("\(day.minutesSpent)")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text("Minutes")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .frame(width: 70, height: 70)
                .background(Color("Brand Color OffWhite"))
                .cornerRadius(13)
                
                VStack {
                    Text("\(day.drills)")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text("Drills")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .frame(width: 70, height: 70)
                .background(Color("Brand Color OffWhite"))
                .cornerRadius(13)
                
                VStack {
                    Text("\(calculateRating(day.minutesSpent, weeklyGoal: weeklyGoal))/5")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text("Rating")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .frame(width: 70, height: 70)
                .background(getRating(day.minutesSpent, weeklyGoal: weeklyGoal))
                .cornerRadius(13)
            }
        }
        .padding(.horizontal)
        .padding()
    }
}

#Preview {
    WeeklyScreen()
}
