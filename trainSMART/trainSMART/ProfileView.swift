//
//  ProfileView.swift
//  trainSMART
//
//  Created by Jugad Singh on 1/6/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
struct ProfileView: View {
    @State var goToLogin = false
    @State var notificationsEnabled = false
    @State var darkMode = false
    @State var dayGoal = 0
    @State var hourGoal = 0.0
    @State var hoursThisWeek = 0.0
    @State var daysThisWeek = 0
    @State var firstName = "Johnny"
    @State var lastName = "Appleseed"
    @State var userEmail = ""
    @State var showEditGoalsSheet = false
    @State var dayGoalString = ""
    @State var hourGoalString = ""
    @State var totalHours = 0.0
    @State var totalDays = 0
    @State var reminderTime = Date()
    @State var isPressed = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                ZStack {
                    Color("Brand Color OffWhite")
                    
                    Image("trainSMARTLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .padding(.top, 20)
                }
                .frame(height: 150)
                .clipped()
                .ignoresSafeArea(edges: .top)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Profile Info
                        VStack(spacing: 10) {
                            Text("Profile")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.white)
                            
                            Text(firstName + " " + lastName)
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            Text(userEmail)
                                .foregroundColor(.white.opacity(0.8))
                                .font(.caption)
                        }
                        
                        // Weekly Goals
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Your Weekly Goals")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.leading, 30)
                                Spacer()
                                HStack {
                                    Button(action: {
                                        showEditGoalsSheet = true
                                    }) {
                                        Text("Edit")
                                            .foregroundColor(Color("Brand Color Blue"))
                                            .padding()
                                            .background(Color("Brand Color OffWhite"))
                                            .cornerRadius(5)
                                    }
                                    .padding(.trailing, 30)
                                }
                                .sheet(isPresented: $showEditGoalsSheet) {
                                    EditGoalsSheet(
                                        isPresented: $showEditGoalsSheet,
                                        currentDayGoal: $dayGoalString,
                                        currentHourGoal: $hourGoalString
                                    )
                                }
                                
                            }
                            
                            HStack {
                                Spacer()
                                GoalCard(title: "Days/Week", value: dayGoal, progress: Double(daysThisWeek), total: Double(dayGoal))
                                Spacer()
                                GoalCard(title: "Hours/Week", value: Int(hourGoal), progress: hoursThisWeek, total: hourGoal)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        
                        // Summary
                        VStack(alignment: .center, spacing: 10) {
                            Text("Training Summary")
                                .font(.headline)
                                .foregroundColor(.white)
                            HStack {
                                SummaryCard(title: "Total Days", value: String(totalDays))
                                SummaryCard(title: "Total Time", value: String(totalHours.rounded()).replacingOccurrences(of: ".0", with: "") + " hrs")
                            }
                        }
                        .padding(.horizontal)
                        
                        // Settings
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Settings")
                                .font(.headline)
                                .padding(.bottom, 5)
                            
                            
                            DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                            
                            Button("Save Settings") {
                                updateUserSettings()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("Dark blue"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .scaleEffect(isPressed ? 0.95 : 1.0)
                            .animation(.easeInOut(duration: 0.15), value: isPressed)
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        isPressed = true
                                    }
                                    .onEnded { _ in
                                        isPressed = false
                                    }
                            )
                            
                        } // VStack
                        .padding()
                        .background(Color("Brand Color OffWhite"))
                        .foregroundColor(.black)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
                        .padding(.horizontal)
                        
                        
                        // Logout
                        Button(action: logout) {
                            Text("Logout")
                                .font(.footnote)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(15)
                                .padding(.horizontal)
                        }
                        .fullScreenCover(isPresented: $goToLogin) {
                            LoginScreen()
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.bottom, 40)
                }
            }
            .background(Color("Brand Color Blue"))
            .ignoresSafeArea(edges: .bottom)
            .onAppear {
                fetchUserSettings()
            }
            .onChange(of: showEditGoalsSheet) { newValue in
                if newValue == false {
                    fetchUserSettings()
                }
            }
        }
    }
    
    
    func logout() {
        do {
            try Auth.auth().signOut()
            goToLogin = true
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    func fetchUserSettings() {
        guard let emailM = Auth.auth().currentUser?.email else { return }
        userDB.document(emailM).getDocument { document, error in
            if let data = document?.data() {
                self.notificationsEnabled = data["notificationsEnabled"] as? Bool ?? false
                self.dayGoal = data["day-goal"] as? Int ?? 0
                self.hourGoal = data["hour-goal"] as? Double ?? 0.0
                self.hoursThisWeek = data["hours-this-week"] as? Double ?? 0.0
                self.daysThisWeek = data["days-this-week"] as? Int ?? 0
                self.firstName = data["firstname"] as? String ?? ""
                self.lastName = data["lastname"] as? String ?? ""
                self.hourGoalString = String(hourGoal)
                self.dayGoalString = String(dayGoal)
                if let mail = Auth.auth().currentUser?.email {
                    self.userEmail = mail
                }
                self.totalHours = data["total-hours"] as? Double ?? 0.0
                self.totalDays = data["total-days"] as? Int ?? 0
                if let timestamp = data["reminder-time"] as? Timestamp {
                    self.reminderTime = timestamp.dateValue()
                }
                
            }
        }
    }
    
    func updateUserSettings() {
        guard let email = Auth.auth().currentUser?.email else { return }
        
        userDB.document(email).updateData([
            "notificationsEnabled": self.notificationsEnabled,
            "reminder-time": self.reminderTime
        ]) { error in
            if let error = error {
                print("❌ Error updating settings: \(error)")
                return
            }
            
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: self.reminderTime)
            let minute = calendar.component(.minute, from: self.reminderTime)
            
            NotificationManager.instance.scheduleDailyNotification(at: hour, minute: minute)
        }
    }
    
    // Helper View for Summary Stats
    struct SummaryCard: View {
        let title: String
        let value: String
        
        var body: some View {
            VStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(width: 100, height: 80)
            .background(Color("Dark blue"))
            .cornerRadius(10)
        }
    }
    struct GoalCard: View {
        let title: String
        let value: Int
        let progress: Double
        let total: Double
        
        var body: some View {
            VStack {
                Text(title)
                    .foregroundColor(Color("Brand Color Blue"))
                    .padding(.top, 25)
                Text("\(value)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Brand Color Blue"))
                ProgressView(value: progress, total: total)
                    .accentColor(Color("Dark blue"))
                    .padding()
            }
            .frame(width: 130, height: 130)
            .background(Color("Brand Color OffWhite"))
            .cornerRadius(10)
        }
    }
}

#Preview {
    ProfileView()
}
