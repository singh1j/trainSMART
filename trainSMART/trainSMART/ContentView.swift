import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            SplashScreen()
        }
    }
}
struct SplashScreen: View {
    @StateObject private var userData = UserData()
    @State private var navigateToLogin = false // State to control navigation
    var body: some View {
        VStack {
            Spacer()
                // Logo Image
                Image("trainSMARTLogo") // Make sure this matches your asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 600, height: 350) // Adjust as per your logo dimensions
            Spacer()
            
            // Tagline
            Text("Train smarter, train harder.")
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.bottom, 70)
            
                
        }
        .background(Color("Brand Color OffWhite")) // Set your background color
        .edgesIgnoringSafeArea(.all)
        .onAppear {
                    // Delay for 2 seconds, then navigate
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        navigateToLogin = true
                    }
                }
                // Navigation to Login Screen
        .fullScreenCover(isPresented: $navigateToLogin) {
            LoginScreen(userData: userData)
//            HomeScreen()
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}



