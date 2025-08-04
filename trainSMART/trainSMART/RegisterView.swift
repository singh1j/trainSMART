//
//  RegisterView.swift
//  trainSMART
//
//  Created by Jugad Singh on 12/24/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Security

struct RegisterScreen: View {
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var goHome = false
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Spacer()
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

                Text("Welcome!")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .padding(.top, 140)

                Group {
                    TextField("First Name", text: $firstname)
                    TextField("Surname", text: $lastname)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    SecureField("Password", text: $password)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 50)
                .padding(.bottom, 10)

                Button(action: {
                    if password.count < 6 {
                        alertMessage = "Password must be at least 6 characters."
                        showingAlert = true
                        return
                    }
                    registerUser(email: email, password: password)
                }) {
                    Text("Register")
                        .foregroundStyle(Color.black)
                        .padding()
                }
                .background(Color("Brand Color OffWhite"))
                .cornerRadius(15)
                .padding(.bottom, 20)
                .fullScreenCover(isPresented: $goHome) {
                    NEWUSERScreen(email: self.email, firstname: self.firstname, lastname: self.lastname)
                }

                NavigationLink(destination: LoginScreen()) {
                    Text("Already have an account? Login here.")
                        .font(.footnote)
                        .foregroundColor(.white)
                }

                Spacer()
            }
            .background(Color("Brand Color Blue"))
            .edgesIgnoringSafeArea(.all)
            .tint(Color("Dark blue"))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Registration Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func registerUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .emailAlreadyInUse:
                    alertMessage = "An account with this email already exists."
                case .invalidEmail:
                    alertMessage = "Please enter a valid email address."
                case .weakPassword:
                    alertMessage = "Password is too weak. Try something stronger."
                default:
                    alertMessage = error.localizedDescription
                }
                showingAlert = true
            } else {
                addUserToDatabase(email: email, firstname: firstname, lastname: lastname)
                if let data = password.data(using: .utf8) {
                    KeychainHelper.shared.save(data, service: "trainsmart.com", account: email)
                    UserDefaults.standard.set(email, forKey: "lastUsedEmail")
                } else {
                    print("Failed to convert password for Keychain")
                }
                goHome = true
            }
        }
    }

    func addUserToDatabase(email: String, firstname: String, lastname: String) {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        let startOfWeek = calendar.date(from: components)!
        userDB.document(email).setData([
            "firstname": firstname,
            "lastname": lastname,
            "hours-this-week": 0,
            "days-this-week": 0,
            "day-goal": 0,
            "hour-goal": 0,
            "total-days": 0,
            "total-hours": 0,
            "settings": [
                "notificationsEnabled": true
            ],
            "last-trained-date": Timestamp(date: Date()),
            "last-weekly-reset": startOfWeek,
        ]) { error in
            if let error = error {
                print("Error adding user to database: \(error.localizedDescription)")
            } else {
                print("User added to database")
            }
        }
    }
}

class KeychainHelper {
    static let shared = KeychainHelper()

    func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)

        let status = SecItemAdd(query, nil)
        if status != errSecSuccess {
            print("Error saving to Keychain: \(status)")
        } else {
            print("Saved to Keychain successfully")
        }
    }

    func read(service: String, account: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)

        return result as? Data
    }

    func delete(service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary

        SecItemDelete(query)
    }
}

#Preview {
    RegisterScreen()
}
