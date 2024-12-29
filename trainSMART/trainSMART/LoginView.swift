import SwiftUI
struct LoginScreen: View {
    @ObservedObject var userData: UserData
    @State private var navigateToHome = false
    @State private var showingAlert = false
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Spacer() // Push content to the center
                    ZStack {
                        Color("Brand Color OffWhite")
                            .frame(height: 250)
                        Image("trainSMARTLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding(.top, 160)
                    }
                    Spacer()
                }
                .frame(height: 20)
                Text("Welcome back!")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .padding(.trailing, 135)
                    .padding(.top, 140)
                
                TextField("Email Address", text: $userData.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                    .padding(.leading, 50)
                    .padding(.trailing, 50)
                
                SecureField("Password", text: $userData.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                    .padding(.leading, 50)
                    .padding(.trailing, 50)
                
                Button("Forgot password?") {}
                    .font(.footnote)
                    .foregroundColor(Color("Brand Color OffWhite"))
                    .padding(.bottom, 20)
                
                Button(action: {
                    if (userData.username != "" && userData.password != "") {
                        navigateToHome = true
                    }
                    else {
                        showingAlert = true
                    }
                }) {
                    Text("Login")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color("Brand Color OffWhite"))
                        .cornerRadius(8)
                }
                .fullScreenCover(isPresented: $navigateToHome) {
                    HomeScreen()
                }
                .alert("Input Username & Password", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                
                Spacer()
                
                NavigationLink(destination: RegisterScreen()) {
                    Text("Don't have an account? Register")
                        .font(.footnote)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 40)
            }
            .background(Color("Brand Color Blue"))
            .edgesIgnoringSafeArea(.all)
            
        }
        .tint(Color("Brand Color Blue"))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen(userData: UserData())
    }
}

class UserData: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
}
