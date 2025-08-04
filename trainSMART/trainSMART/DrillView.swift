import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import YouTubePlayerKit

// MARK: - Drill Model
struct Drill: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var rsrcs: String
    var time: Int
    var diff: Int
    var positions: String
    var skillsTrained: [String]
    var url: String
    var fieldreq: String
    var icon: String
    var descr: String
    var credit: String
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case rsrcs
        case time
        case diff
        case positions
        case skillsTrained = "skills-trained"
        case url
        case fieldreq = "field-req"
        case icon
        case descr
        case credit
    }
}

// MARK: - ViewModel
class DrillViewModel: ObservableObject {
    @Published var drill: Drill?
    @Published var isLoading = true
    @Published var error: String?
    
    func fetchDrill(named name: String) {
        print("DrillScreen received name: \(name)")
        let db = Firestore.firestore()
        let docRef = db.collection("drills").document(name)

        docRef.getDocument { snapshot, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = error.localizedDescription
                    self.isLoading = false
                    return
                }

                if let snapshot = snapshot, snapshot.exists {
                    do {
                        self.drill = try snapshot.data(as: Drill.self)
                    } catch {
                        self.error = "Failed to decode drill: \(error.localizedDescription)"
                    }
                } else {
                    self.error = "Drill not found."
                }

                self.isLoading = false
            }
        }
    }
}

// MARK: - Drill Screen View
struct DrillScreen: View {
    let name: String
    @StateObject private var viewModel = DrillViewModel()
    @State private var goToLog = false
    @State private var timer: Timer? = nil
    @State private var logConfirmationShown = false
    @State private var startTime: Date?
    @State private var elapsedSeconds: Int = 0
    @State private var isRunning = false
    @State private var displayTimer: Timer?
    @State private var lastActiveDate: Date?
    @StateObject private var drillTimer = DrillTimer()


    func colorForDifficulty(_ diff: Int) -> Color {
        switch diff {
        case 5: return Color.purple
        case 4: return Color.red.opacity(0.8)
        case 3: return Color.orange
        case 2: return Color.yellow.opacity(0.8)
        default: return Color.green.opacity(0.8)
        }
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Header
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
                    .padding(.bottom)

                    // Content
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxHeight: .infinity)
                    } else if let drill = viewModel.drill {
                        ScrollView {
                            Text(drill.name)
                                .font(.title)
                                .foregroundStyle(.white)

                            YouTubePlayerView(YouTubePlayer(stringLiteral: drill.url))
                                .aspectRatio(16/9, contentMode: .fit)
                            Text(drill.credit)
                                .font(.caption)
                                .foregroundStyle(Color.white)
                                .padding(25)
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(drill.name)
                                        .foregroundStyle(.white)
                                    HStack {
                                        Image(systemName: "soccerball")
                                            .foregroundStyle(.white)
                                        Text(drill.rsrcs)
                                            .font(.caption)
                                            .foregroundStyle(.white)
                                    }
                                }
                                .padding()
                                Spacer()
                                VStack {
                                    Image(systemName: "timer")
                                        .font(.title)
                                        .foregroundStyle(.white)
                                    Text("\(drill.time) Minutes")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                }
                                .padding()
                                Spacer()
                                Image(systemName: "\(drill.icon)")
                                    .font(.title)
                                    .foregroundStyle(.white)
                                    .padding()
                            }
                            .background(Color("Dark blue"))
                            .cornerRadius(15)
                            .padding()

                            // Metrics
                            HStack {
                                VStack {
                                    Text("\(drill.diff)")
                                        .font(.title)
                                        .padding(.top)
                                        .foregroundStyle(.black)
                                    Text("Difficulty")
                                        .font(.caption)
                                        .foregroundStyle(.black)
                                        .padding([.bottom, .trailing, .leading])
                                }
                                .background(colorForDifficulty(drill.diff))
                                .cornerRadius(15)
                                .padding()

                                Spacer()

                                VStack {
                                    Text("\(drill.time)")
                                        .font(.title)
                                        .foregroundStyle(.black)
                                        .padding(.top)
                                    Text("Minutes")
                                        .font(.caption)
                                        .foregroundStyle(.black)
                                        .padding([.bottom, .trailing, .leading])
                                }
                                .background(Color.white)
                                .cornerRadius(15)
                                .padding()

                                Spacer()

                                VStack {
                                    Text("\(drill.fieldreq)")
                                        .font(.title)
                                        .foregroundStyle(.black)
                                        .padding(.top)
                                    Text("Of the Field")
                                        .font(.caption)
                                        .foregroundStyle(.black)
                                        .padding([.bottom, .trailing, .leading])
                                }
                                .background(Color.white)
                                .cornerRadius(15)
                                .padding()
                            }

                            // Description and Categories
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Positions")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.top)

                                Text(drill.positions)
                                    .font(.subheadline)
                                    .foregroundColor(.white)

                                Text("Skills Trained")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.top)

                                Text(drill.skillsTrained.joined(separator: ", "))
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                
                                Text("Description")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.top)

                                Text(drill.descr)
                                    .font(.subheadline)
                                    .foregroundColor(.white)

                                // --- New Logging UI ---
                                Divider().padding(.vertical)

                                Text("Track Your Session")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Text("\(drillTimer.elapsedSeconds / 60) min \(drillTimer.elapsedSeconds % 60) sec")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(.bottom, 5)



                                HStack {
                                    Button(action: {
                                        if drillTimer.isRunning {
                                            drillTimer.pause()
                                        } else {
                                            drillTimer.start()
                                        }
                                    }) {
                                        Text(drillTimer.elapsedSeconds == 0 ? "Start" : (drillTimer.isRunning ? "Pause" : "Resume"))
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.white)
                                            .foregroundColor(.black)
                                            .cornerRadius(10)
                                    }

                                    if drillTimer.elapsedSeconds > 0 || drillTimer.isRunning {
                                        Button("Reset") {
                                            drillTimer.reset()
                                        }
                                        .padding()
                                        .foregroundColor(.red)
                                    }


                                    if elapsedSeconds > 0 || isRunning {
                                        Button("Reset") {
                                            displayTimer?.invalidate()
                                            displayTimer = nil
                                            isRunning = false
                                            elapsedSeconds = 0
                                            startTime = nil
                                        }
                                        .padding()
                                        .foregroundColor(.red)
                                    }


                                }

                                Button(action: {
                                    let minutesToLog = (drillTimer.computedElapsedTime) / 60
                                    print("⏱️ Computed Elapsed Time: \(drillTimer.computedElapsedTime) seconds")
                                    print("📝 Logging \(minutesToLog) minutes")

                                    logDrillSession(minutes: minutesToLog, drills: 1, rating: 3)
                                    logConfirmationShown = true
                                    drillTimer.reset()
                                }) {
                                    Text("Log Session")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color("Dark blue"))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding(.top)

                                .alert("Session Logged!", isPresented: $logConfirmationShown) {
                                    Button("OK", role: .cancel) { }
                                }


                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        }
                    } else if let error = viewModel.error {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .background(Color("Brand Color Blue"))
            }
            .edgesIgnoringSafeArea(.top)
        }
        .task {
            viewModel.fetchDrill(named: name)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            if isRunning {
                // Resume updating display
                startDisplayTimer()
            }
        }
        .onDisappear {
            displayTimer?.invalidate()
        }


    }
    var computedElapsedTime: Int {
        if isRunning, let start = startTime {
            return elapsedSeconds + Int(Date().timeIntervalSince(start))
        } else {
            return elapsedSeconds
        }
    }



    func logDrillSession(minutes: Int, drills: Int, rating: Int) {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        let userRef = userDB.document(userEmail)
        print("LOGGING --- "+String(minutes))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeek = dateFormatter.string(from: Date()).lowercased()
        let todayStart = Calendar.current.startOfDay(for: Date())

        let dailyStatsRef = userRef.collection("daily").document(dayOfWeek)

        dailyStatsRef.getDocument { (document, error) in
            let currentMinutes = document?.data()?["minutes"] as? Int ?? 0
            let currentDrills = document?.data()?["drills"] as? Int ?? 0

            let newDailyData: [String: Any] = [
                "minutes": currentMinutes + minutes,
                "drills": currentDrills + drills,
                "rating": rating,
                "timestamp": Timestamp(date: Date()),
                "completed": true
            ]

            dailyStatsRef.setData(newDailyData, merge: true)
        }

        userRef.getDocument { (document, error) in
            let lastTrainedTimestamp = document?.data()?["last-trained-date"] as? Timestamp
            let lastTrainedDate = lastTrainedTimestamp?.dateValue()
            let lastTrainedDay = lastTrainedDate.map { Calendar.current.startOfDay(for: $0) }

            let shouldIncrementDay = (lastTrainedDay != todayStart)

            var updates: [String: Any] = [
                "hours-this-week": FieldValue.increment(Double(minutes) / 60.0),
                "total-hours": FieldValue.increment(Double(minutes) / 60.0),
                "last-trained-date": Timestamp(date: todayStart)
            ]

            if shouldIncrementDay {
                updates["days-this-week"] = FieldValue.increment(Int64(1))
                updates["total-days"] = FieldValue.increment(Int64(1))
            }

            userRef.updateData(updates)
        }

    }
    func startDisplayTimer() {
        displayTimer?.invalidate()
        displayTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let start = startTime {
                let liveElapsed = elapsedSeconds + Int(Date().timeIntervalSince(start))
                // Use this to update a UI label if needed
                print("Live time: \(liveElapsed) seconds")
            }
        }
    }

}

class DrillTimer: ObservableObject {
    @Published var elapsedSeconds = 0
    @Published var isRunning = false

    private var accumulatedSeconds = 0
    private var timer: Timer?
    private var startDate: Date?

    func start() {
        startDate = Date()
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            guard let start = self.startDate else { return }
            let currentElapsed = Int(Date().timeIntervalSince(start))
            self.elapsedSeconds = self.accumulatedSeconds + currentElapsed
        }
    }

    func pause() {
        if let start = startDate {
            accumulatedSeconds += Int(Date().timeIntervalSince(start))
        }
        startDate = nil
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    func reset() {
        startDate = nil
        accumulatedSeconds = 0
        elapsedSeconds = 0
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    var computedElapsedTime: Int {
        if let start = startDate {
            return accumulatedSeconds + Int(Date().timeIntervalSince(start))
        } else {
            return accumulatedSeconds
        }
    }
}
