import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct Quote: Identifiable, Codable {
    @DocumentID var id: String?
    var text: String
    var author: String
}

struct HomeScreen: View {
    class QuoteViewModel: ObservableObject {
        @Published var randomQuote: Quote?

        func fetchRandomQuote() {
            let db = Firestore.firestore()
            db.collection("quotes").getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching quotes: \(error)")
                    return
                }

                guard let docs = snapshot?.documents, !docs.isEmpty else {
                    print("No quotes found")
                    return
                }

                let allQuotes = docs.compactMap { try? $0.data(as: Quote.self) }
                self.randomQuote = allQuotes.randomElement()
            }
        }
    }
    @State var goToCatalog = false
    @State var goToWeekly = false
    @State private var daysTrained = 0
    @State private var hoursTrained = 0.0
    @State var dayGoal = 0
    @State var hourGoal = 0.0
    @State private var shouldRefresh = false
    @StateObject private var quoteVM = QuoteViewModel()
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Logo section with adjusted size and no unnecessary space
                    ZStack {
                        Color("Brand Color OffWhite")
                            .frame(height: 150) // Reduced height of the logo section
                        Image("trainSMARTLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150) // Adjusted logo height
                            .padding(.top, 20) // Adjust top padding to place logo correctly
                    }
                    .frame(height: 150) // Ensures the logo section is fixed at the top

                    // ScrollView for the rest of the content
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            // "This Week" Section
                            HStack {
                                Text("This Week...")
                                    .padding(.leading, 40)
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                                Spacer()
                                Button(action: {
                                    goToWeekly = true
                                }) {
                                    Text("See More")
                                        .foregroundColor(.black)
                                        .padding(10)
                                        .font(.system(size: 12))
                                        .background(Color("Brand Color OffWhite"))
                                        .cornerRadius(8)
                                }
                                .padding(.trailing, 40)
                                .navigationDestination(isPresented: $goToWeekly) {
                                    WeeklyScreen()
                                }
                            }
                            .padding(.top, 40) // Reduced top padding
                            .padding(.bottom, 15)
                            
                            // Days and Hours Trained Section
                            HStack {
                                VStack {
                                    Text("Days Trained")
                                        .foregroundColor(Color("Blue-gray"))
                                        .font(.system(size: 20))
                                        .padding(.bottom, 5)
                                    Text("\(daysTrained)")
                                        .font(.system(size: 30))
                                        .foregroundColor(daysTrained > dayGoal ? Color("Green") : .red)
                                }
                                .padding(.leading, 60)
                                Spacer()
                                VStack {
                                    Text("Hours Trained")
                                        .foregroundColor(Color("Blue-gray"))
                                        .font(.system(size: 20))
                                        .padding(.bottom, 5)
                                    Text(String(format: "%.1f", hoursTrained))
                                        .font(.system(size: 30))
                                        .foregroundColor(hoursTrained > hourGoal ? Color("Green") : .red)
                                }
                                .padding(.trailing, 60)
                            }
                            .padding(.bottom, 50)
                            
                            // Training Section
                            HStack {
                                Text("Training")
                                    .padding(.leading, 80)
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                                Spacer()
                                Button(action: {
                                    goToCatalog = true
                                }) {
                                    Text("View All")
                                        .foregroundColor(.black)
                                        .padding(10)
                                        .font(.system(size: 12))
                                        .background(Color("Brand Color OffWhite"))
                                        .cornerRadius(8)
                                }
                                .padding(.trailing, 80)
                                .navigationDestination(isPresented: $goToCatalog) {
                                    CatalogScreen()
                                }
                            }
                            .padding(.bottom)
                            
                            // Image Section with field image
                            NavigationLink(destination: NewTrainingScreen()) {
                                        ZStack {
                                            Image("field-image")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 220)
                                                .clipShape(RoundedRectangle(cornerRadius: 47))

                                            VStack(alignment: .leading, spacing: 0) {
                                                HStack {
                                                    VStack {
                                                        Image(systemName: "sportscourt.fill")
                                                        Text("Let's Train")
                                                    }
                                                    .font(.system(size: 17))
                                                    .foregroundColor(.black)
                                                    .padding(.leading)
                                                    .padding(.top)
                                                    .padding(.bottom)

                                                    Spacer()

                                                    Text("See Available Drills")
                                                        .padding()
                                                        .font(.system(size: 15))
                                                        .foregroundColor(.black)
                                                }
                                                .padding(.horizontal)
                                                .frame(width: 350)
                                                .background(Color("Brand Color OffWhite"))
                                                .cornerRadius(15)
                                            }
                                            .padding(.horizontal)
                                            .padding(.top, 150)
                                        }
                                        .padding(.bottom, 50)
                                    }
                        
                            
                            // Quote Section
                            if let quote = quoteVM.randomQuote {
                                VStack {
                                    HStack {
                                        Image(systemName: "quote.bubble")
                                            .padding()
                                            .font(.system(size: 25))
                                        Spacer()
                                        Text("\(quote.author)")
                                            .padding()
                                    }
                                    Text("\(quote.text)")
                                        .padding()
                                }
                                .background(Color("Blue-gray"))
                                .cornerRadius(15)
                                .frame(width: 330)
                                .padding(.bottom, 50)
                            }
                        }
                        .background(Color("Brand Color Blue"))
                        .padding(.top, 0)
                    }
                    .padding(.bottom, 0) // Remove extra padding at the bottom
                }
                .background(Color("Brand Color Blue"))
            }
            .edgesIgnoringSafeArea(.top) // Ensures the top of the screen is used without extra black space
        }
        .tint(Color("Dark blue"))
        .onAppear {
            refreshPage()
            // Add observer for refresh notification
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("RefreshHomeView"),
                object: nil,
                queue: .main) { _ in
                    refreshPage()
                }
        }
        .onChange(of: shouldRefresh) { _ in
            refreshPage()
        }
    }
    func refreshPage() {
        if let userEmail = Auth.auth().currentUser?.email {
            let userRef = userDB.document(userEmail)
            checkAndResetWeeklyStatsIfNeeded(for: userRef)
        }
        quoteVM.fetchRandomQuote()

    }

    func getDaysTrained() {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        
        userDB.document(userEmail)
            .collection("daily")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                
                // Count days that have minutes > 0
                let trainedDays = querySnapshot?.documents.filter { document in
                    let minutes = document.data()["minutes"] as? Int ?? 0
                    return minutes > 0
                }.count ?? 0
                userDB.document(userEmail).setData(["days-this-week": trainedDays], merge: true)
                DispatchQueue.main.async {
                    self.daysTrained = trainedDays
                }
            }
    }
    func getHoursTrained() {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        
        // Get all documents from daily collection
        userDB.document(userEmail)
            .collection("daily")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                
                var totalMinutes = 0
                
                // Sum up all minutes from each day
                for document in querySnapshot?.documents ?? [] {
                    let minutes = document.data()["minutes"] as? Int ?? 0
                    totalMinutes += minutes
                }
                
                // Convert total minutes to hours
                DispatchQueue.main.async {
                    self.hoursTrained = Double(totalMinutes) / 60.0
                }
            }
    }
    func getGoals() {
        userDB.document(userID ?? "").getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                DispatchQueue.main.async {
                    self.dayGoal = data?["day-goal"] as? Int ?? 30
                    self.hourGoal = data?["hour-goal"] as? Double ?? 100.0
                }
            }
        }
        print($hourGoal, $dayGoal)
    }
    func checkIfTrainingIsRecent(completion: @escaping (Bool) -> Void) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            completion(true)
            return
        }

        userDB.document(userEmail).getDocument { document, error in
            guard error == nil, let document = document, document.exists else {
                completion(true)
                return
            }

            if let lastTrainedTimestamp = document.data()?["last-trained-date"] as? Timestamp {
                let lastTrainedDate = lastTrainedTimestamp.dateValue()
                let now = Date()
                let difference = Calendar.current.dateComponents([.day], from: lastTrainedDate, to: now)

                if let days = difference.day, days > 7 {
                    print("Last trained over a week ago (\(days) days). Resetting stats.")
                    completion(false) // More than 7 days = not recent
                } else {
                    print("Trained within the past week.")
                    completion(true)
                }
            } else {
                print("No last-trained-date found. Assuming recent.")
                completion(true)
            }
        }
    }
    func resetWeeklyStatsAndDailyData() {
        guard let userEmail = Auth.auth().currentUser?.email else { return }

        let userRef = userDB.document(userEmail)
        let dailyCollectionRef = userRef.collection("daily")

        // Fetch all daily docs first
        dailyCollectionRef.getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching daily docs: \(error)")
                return
            }

            // Use Firestore's batch from the same Firestore instance your userDB came from
            let batch = userRef.firestore.batch()

            // Delete all daily docs
            snapshot?.documents.forEach { doc in
                batch.deleteDocument(doc.reference)
            }

            // Reset weekly stats and last-trained-date
            batch.updateData([
                "hours-this-week": 0,
                "days-this-week": 0,
                "last-trained-date": Timestamp(date: Date())
            ], forDocument: userRef)

            // Commit the batch
            batch.commit { error in
                if let error = error {
                    print("❌ Error committing reset batch: \(error)")
                } else {
                    print("✅ Successfully reset weekly stats and cleared daily data")
                    DispatchQueue.main.async {
                        self.daysTrained = 0
                        self.hoursTrained = 0
                    }
                }
            }
        }
    }
    func checkAndResetWeeklyStatsIfNeeded(for userRef: DocumentReference) {
        userRef.getDocument { (snapshot, error) in
            guard let data = snapshot?.data(), error == nil else {
                print("❌ Error fetching user for weekly reset check")
                return
                
            }

            let calendar = Calendar.current
            let now = Date()
            let currentWeek = calendar.component(.weekOfYear, from: now)
            let currentYear = calendar.component(.yearForWeekOfYear, from: now)

            let lastResetTimestamp = data["last-weekly-reset"] as? Timestamp
            let lastResetDate = lastResetTimestamp?.dateValue()

            let lastResetWeek = lastResetDate.map { calendar.component(.weekOfYear, from: $0) }
            let lastResetYear = lastResetDate.map { calendar.component(.yearForWeekOfYear, from: $0) }

            let needsReset = (lastResetWeek == nil || lastResetWeek! < currentWeek || lastResetYear! < currentYear)
            // Find the most recent Sunday
            let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
            let startOfWeek = calendar.date(from: components)!

            if needsReset {
                print("✅ Weekly reset triggered")

                // Reset weekly stats
                userRef.updateData([
                    "hours-this-week": 0,
                    "days-this-week": 0,
                    "last-weekly-reset": Timestamp(date: startOfWeek)
                ]) { err in
                    if let err = err {
                        print("❌ Failed to reset weekly stats: \(err)")
                    } else {
                        print("✅ Weekly stats reset")
                        DispatchQueue.main.async {
                                        self.getDaysTrained()
                                        self.getHoursTrained()
                        }
                    }
                }

                // Reset all daily docs (optional)
                let days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
                for day in days {
                    userRef.collection("daily").document(day).setData([
                        "minutes": 0,
                        "drills": 0,
                        "rating": 0,
                        "completed": false
                    ], merge: true)
                }
            } else {
                print("No weekly reset needed")
                DispatchQueue.main.async {
                    self.getDaysTrained()
                    self.getHoursTrained()
                }
            }
        }
    }






}
