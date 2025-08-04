import Foundation
import FirebaseFirestore

class DrillResultsViewModel: ObservableObject {
    @Published var drills: [Drill] = []
    @Published var isLoading = true
    @Published var error: String?

    func fetchFilteredDrills(skills: Set<String>, field: String, resources: Set<String>) {
        let db = Firestore.firestore()

        db.collection("drills")
            .whereField("skills-trained", arrayContainsAny: Array(skills))
            .getDocuments { snapshot, err in
                DispatchQueue.main.async {
                    self.isLoading = false

                    if let err = err {
                        self.error = err.localizedDescription
                        return
                    }

                    guard let documents = snapshot?.documents else {
                        self.drills = []
                        return
                    }

                    let fieldRank: [String: Int] = [
                        "n/a": 0,
                        "1/8": 1,
                        "1/4": 2,
                        "1/2": 3,
                        "full": 4
                    ]

                    let normalizedSelectedResources = Set(resources.map {
                        $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                    })
                    let userFieldSizeRank = fieldRank[field.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)] ?? 0

                    self.drills = documents.compactMap { doc in
                        var drill = try? doc.data(as: Drill.self)
                        drill?.id = doc.documentID
                        return drill
                    }
                    .filter { drill in
                        // Normalize drill field
                        let drillFieldKey = drill.fieldreq.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                        let drillFieldRank = fieldRank[drillFieldKey] ?? Int.max
                        let fieldMatch = drillFieldRank <= userFieldSizeRank

                        // Normalize and check each required resource group
                        let drillResourceGroups = drill.rsrcs
                            .components(separatedBy: ",")
                            .map {
                                $0.components(separatedBy: "/").map {
                                    $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                                }
                            }

                        let resourceMatch = drillResourceGroups.allSatisfy { group in
                            group.contains(where: { normalizedSelectedResources.contains($0) })
                        }

                        return fieldMatch && resourceMatch
                    }
                }
            }
    }

}
