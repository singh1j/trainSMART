import SwiftUI
struct TrainingHeader: View {
    var body: some View {
        ZStack {
            Color("Brand Color OffWhite")
                .ignoresSafeArea(edges: .top)

            Image("trainSMARTLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 130) // slightly less to balance
        }
        .frame(height: 150)
    }
}
