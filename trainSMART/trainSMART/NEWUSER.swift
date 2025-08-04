import SwiftUI
import FirebaseFirestore

struct NEWUSERScreen: View {
    let levelOptions = ["Don't Play", "Recreational", "JV", "Varsity", "College", "Semi-Pro", "Pro"]

    @State private var currentLevel = "Don't Play"
    @State private var goalLevel = "Don't Play"
    @State private var goHome = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State var email: String
    @State var firstname: String
    @State var lastname: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack {
                    Spacer()
                    ZStack {
                        Color("Brand Color OffWhite")
                            .frame(height: 250)
                        Image("trainSMARTLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding(.top, 160)
                    }
                    Spacer()
                }
                .frame(height: 20)

                Spacer(minLength: 10)

                Text("Let's get to know you")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Here's where I play right now:")
                            .foregroundColor(.white)
                            .font(.caption)

                        Picker("Current Level", selection: $currentLevel) {
                            ForEach(levelOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 1)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Goal – where do you want trainSMART to take you?")
                            .foregroundColor(.white)
                            .font(.caption)

                        Picker("Goal Level", selection: $goalLevel) {
                            ForEach(levelOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 1)
                    }
                }
                .padding(.horizontal, 30)

                Button(action: {
                    let (hourGoal, dayGoal) = calculateGoals(current: currentLevel, goal: goalLevel)
                    addUserToDatabase(currentLevel: currentLevel, goalLevel: goalLevel, hourGoal: hourGoal, dayGoal: dayGoal)
                    goHome = true
                }) {
                    Text("Continue")
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("Brand Color OffWhite"))
                        .cornerRadius(15)
                        .shadow(radius: 2)
                }
                .padding(.horizontal, 50)
                .padding(.top, 30)

                Spacer()
            }
            .background(Color("Brand Color Blue"))
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $goHome) {
                LoginScreen()
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Oops"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func calculateGoals(current: String, goal: String) -> (Int, Int) {
        let currentIndex = levelOptions.firstIndex(of: current) ?? 0
        let goalIndex = levelOptions.firstIndex(of: goal) ?? 0

        if currentIndex == goalIndex {
            return (3, 2)
        } else if currentIndex < goalIndex {
            return (5, 4)
        } else {
            return (2, 1)
        }
    }

    func addUserToDatabase(currentLevel: String, goalLevel: String, hourGoal: Int, dayGoal: Int) {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        let startOfWeek = calendar.date(from: components)!

        let docRef = userDB.document(email)

        docRef.setData([
            "current-level": currentLevel,
            "goal-level": goalLevel,
            "hours-this-week": 0,
            "days-this-week": 0,
            "day-goal": dayGoal,
            "hour-goal": hourGoal,
            "total-days": 0,
            "total-hours": 0,
            "settings": [
                "notificationsEnabled": true
            ],
            "last-trained-date": Timestamp(date: Date()),
            "last-weekly-reset": startOfWeek,
            "firstname": firstname,
            "lastname": lastname
        ]) { error in
            if let error = error {
                alertMessage = "Failed to save preferences: \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
}
