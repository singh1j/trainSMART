import SwiftUI
import FirebaseFirestore

struct DrillItem: Identifiable {
    var id: String
    var name: String
    var displayName: String
    var icon: String
}

struct DrillCatScreen: View {
    var skill: String
    @State private var drills: [DrillItem] = []
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            GeometryReader {geometry in
                ZStack(alignment: .top) {
                    Color("Brand Color OffWhite")
                        .edgesIgnoringSafeArea(.top)
                    
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
                        
                        if isLoading {
                            ProgressView("Loading drills...")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color("Brand Color Blue"))
                        } else if drills.isEmpty {
                            Text("No drills found for \(skill).")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color("Brand Color Blue"))
                        } else {
                            ScrollView {
                                VStack(spacing: 20) {
                                    ForEach(drills, id: \.id) { drill in
                                        NavigationLink(destination: DrillScreen(name: drill.name)) {
                                            HStack(spacing: 15) {
                                                // Optional: Drill icon
                                                Image(systemName: drill.icon) // Replace with drill.icon if available
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 30, height: 30)
                                                    .foregroundColor(.black)

                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(drill.displayName)
                                                        .font(.system(size: 20, weight: .semibold))
                                                        .foregroundColor(.black)

                                                    // Optional subtitle, if you have something like drill.skillsTrained.first
                                                    Text("Tap to view drill")
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                }

                                                Spacer()

                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(.gray)
                                            }
                                            .padding()
                                            .background(Color("Brand Color OffWhite"))
                                            .cornerRadius(15)
                                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                            .padding(.horizontal)
                                            .padding(.vertical, 5)
                                            .tint(Color("Dark blue"))
                                        }
                                    }

                                }
                                .padding(.top, 20)
                                .padding(.bottom, 50)
                            }
                            .background(Color("Brand Color Blue"))
                        }
                    }
                    .background(Color("Brand Color Blue"))
                    .edgesIgnoringSafeArea(.top)
                    .onAppear {
                        fetchDrills(for: skill)
                    }
                }
            }
        }
        .tint(Color("Dark blue"))
    }

    func fetchDrills(for skill: String) {
        let db = Firestore.firestore()
        db.collection("drills")
            .whereField("skills-trained", arrayContains: skill)
            .getDocuments { snapshot, error in
                isLoading = false
                if let error = error {
                    print("Error fetching drills: \(error)")
                    return
                }

                drills = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    let id = doc.documentID
                    let name = data["name"] as? String
                    let icon = data["icon"] as? String
                    return DrillItem(id: doc.documentID, name: id, displayName: name ?? "Drill", icon: icon ?? "soccerball")
                } ?? []
            }
    }
}


