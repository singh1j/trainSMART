import SwiftUI

struct DrillResultsScreen: View {
    let selectedSkills: Set<String>
    let selectedFieldSize: String
    let selectedResources: Set<String>

    @StateObject private var viewModel = DrillResultsViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Finding drills...")
                    .padding()
            } else if let error = viewModel.error {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.drills.isEmpty {
                Text("No matching drills found.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.drills) { drill in
                            NavigationLink(destination: DrillScreen(name: drill.id ?? drill.name)) {
                                HStack(spacing: 15) {
                                    Image(systemName: drill.icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.black)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(drill.name)
                                            .font(.headline)
                                            .foregroundColor(.black)

                                        Text("\(drill.time) min • Field: \(drill.fieldreq)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    // Difficulty Badge
                                    Text("\(drill.diff)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(8)
                                        .frame(width: 30, height: 30)
                                        .background(colorForDifficulty(drill.diff))
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color("Brand Color OffWhite"))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top)
                }
            }
        }
        .onAppear {
            if viewModel.drills.isEmpty && viewModel.isLoading {
                viewModel.fetchFilteredDrills(
                    skills: selectedSkills,
                    field: selectedFieldSize,
                    resources: selectedResources
                )
            }
        }
        .background(Color("Brand Color Blue"))
        .tint(Color("Dark blue"))
    }

    // MARK: - Difficulty Color
    func colorForDifficulty(_ diff: Int) -> Color {
        switch diff {
        case 5: return Color.purple
        case 4: return Color.red.opacity(0.8)
        case 3: return Color.orange
        case 2: return Color.yellow.opacity(0.8)
        default: return Color.green.opacity(0.8)
        }
    }
}
