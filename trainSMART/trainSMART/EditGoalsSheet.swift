import SwiftUI
import FirebaseAuth

struct EditGoalsSheet: View {
    @Binding var isPresented: Bool
    @Binding var currentDayGoal: String
    @Binding var currentHourGoal: String

    @State private var tempDayGoal: Int = 3
    @State private var tempHourGoal: Double = 5.0

    var body: some View {
        VStack(spacing: 30) {
            Text("Update Weekly Goals")
                .font(.headline)

            Stepper("Days per Week: \(tempDayGoal)", value: $tempDayGoal, in: 1...7)

            Stepper("Hours per Week: \(String(format: "%.1f", tempHourGoal))", value: $tempHourGoal, in: 0...40, step: 0.5)

            Button("Save") {
                updateWeeklyGoals(days: tempDayGoal, hours: tempHourGoal)
                currentDayGoal = "\(tempDayGoal)"
                currentHourGoal = String(format: "%.1f", tempHourGoal)
                isPresented = false
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("Dark blue"))
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Cancel") {
                isPresented = false
            }
            .foregroundColor(.red)

            Spacer()
        }
        .padding()
        .onAppear {
            tempDayGoal = Int(currentDayGoal) ?? 3
            tempHourGoal = Double(currentHourGoal) ?? 5.0
        }
    }

    func updateWeeklyGoals(days: Int, hours: Double) {
        guard let userEmail = Auth.auth().currentUser?.email else { return }

        userDB.document(userEmail).updateData([
            "day-goal": days,
            "hour-goal": hours
        ]) { error in
            if let error = error {
                print("❌ Failed to update goals: \(error.localizedDescription)")
            } else {
                print("✅ Goals updated successfully")
            }
        }
    }
}
