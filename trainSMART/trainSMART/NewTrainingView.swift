import SwiftUI

struct NewTrainingScreen: View {
    @State private var selectedResources: Set<String> = []
    @State private var selectedFieldSize = "1/4"
    @State private var selectedSkill: Set<String> = []
    @State private var showResults = false

    let resources = ["Ball", "Cones", "Goal", "Mini Goal", "Partner", "Wall"]
    let fieldSizes = ["1/8", "1/4", "1/2", "Full", "N/A"]
    let skills = ["Dribbling", "Passing", "Shooting", "Defending", "Touch/Control"]
    init() {
            let selectedAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(Color.purple)
            ]
            let normalAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(Color.black)
            ]

            UISegmentedControl.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        }
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
                .clipped() // Ensures nothing spills over
                .background(Color("Brand Color OffWhite"))

                // Scrollable Form Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Resources Section
                        SectionCard(title: "Select Resources:") {
                            ForEach(resources, id: \.self) { item in
                                Toggle(item, isOn: Binding(
                                    get: { selectedResources.contains(item) },
                                    set: { isOn in
                                        if isOn {
                                            selectedResources.insert(item)
                                        } else {
                                            selectedResources.remove(item)
                                        }
                                    }
                                ))
                            }
                        }

                        // Field Size Section
                        SectionCard(title: "Select Field Size:") {
                            Picker("Field Size", selection: $selectedFieldSize) {
                                ForEach(fieldSizes, id: \.self) { size in
                                    Text(size)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .tint(Color("Dark blue"))
                        }

                        // Skills Section
                        SectionCard(title: "Select Skills:") {
                            ForEach(skills, id: \.self) { skill in
                                SkillToggle(skill: skill, selectedSkills: $selectedSkill)
                            }
                        }

                        // Action Button

                        NavigationLink(
                            destination: DrillResultsScreen(
                                selectedSkills: selectedSkill,
                                selectedFieldSize: selectedFieldSize,
                                selectedResources: selectedResources
                            )
                        ) {
                            Text("Show Available Drills")
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("Lavender"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }


                    }
                    .padding()
                }
                .background(Color("Brand Color Blue"))

                .background(Color("Brand Color Blue"))
            }
            .background(Color("Brand Color Blue"))
            .ignoresSafeArea(edges: .top) // <- This is the KEY
        }
        .tint(Color("Dark blue"))
    }
}

struct SkillToggle: View {
    var skill: String
    @Binding var selectedSkills: Set<String>

    var body: some View {
        Toggle(skill, isOn: Binding(
            get: { selectedSkills.contains(skill) },
            set: { isOn in
                if isOn {
                    selectedSkills.insert(skill)
                } else {
                    selectedSkills.remove(skill)
                }
            }
        ))
    }
}
struct SectionCard<Content: View>: View {
    var title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 10) {
                content
            }
            .padding()
            .background(Color.white)
            .foregroundColor(Color("Dark blue"))
            .cornerRadius(10)
        }
    }
}
