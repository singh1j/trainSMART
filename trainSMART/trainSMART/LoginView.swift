import SwiftUI
import FirebaseAuth
struct LoginScreen: View {
    @State private var navigateToHome = false
    @State private var showingAlert = false
    @State private var success = false
    @State private var username = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false
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
                
                TextField("Email Address", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                    .padding(.leading, 50)
                    .padding(.trailing, 50)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                    .padding(.leading, 50)
                    .padding(.trailing, 50)
                
                Button("Forgot password?") {}
                    .font(.footnote)
                    .foregroundColor(Color("Brand Color OffWhite"))
                    .padding(.bottom, 20)
                
                Button(action: {
                    if (username != "" || password != "") {
                        handleLogin()
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
                    MainTabView()
                }
                .alert("Input Username & Password", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                .alert("Error", isPresented: $showError) {
                    Text(errorMessage)
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
        .onAppear {
            print("LoginScreen appeared")
            if let lastEmail = UserDefaults.standard.string(forKey: "lastUsedEmail") {
                print("Found saved email: \(lastEmail)")
                self.username = lastEmail
                if let savedPasswordData = KeychainHelper.shared.read(service: "trainsmart.com", account: lastEmail),
                   let savedPassword = String(data: savedPasswordData, encoding: .utf8) {
                    self.password = savedPassword
                    print("Autofilled saved credentials")
                } else {
                    print("No saved password found for \(lastEmail)")
                }
            } else {
                print("No saved email in UserDefaults")
            }
        }


        
    }
    func handleLogin() {
        Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
            if let error = error {
                self.showError = true
                self.errorMessage = error.localizedDescription
                return
            }

            // Save credentials to Keychain
            let normalizedEmail = username.lowercased()
            UserDefaults.standard.set(normalizedEmail, forKey: "lastUsedEmail")
            if let passwordData = password.data(using: .utf8) {
                KeychainHelper.shared.save(passwordData, service: "trainsmart.com", account: normalizedEmail)
            }
            // Navigate to home
            withAnimation {
                self.isLoggedIn = true
                self.navigateToHome = true
            }
        }
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
