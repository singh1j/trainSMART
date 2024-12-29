//
//  RegisterView.swift
//  trainSMART
//
//  Created by Jugad Singh on 12/24/24.
//

import SwiftUI

struct RegisterScreen: View {
    @EnvironmentObject var userdata: UserData
    var body: some View {
        VStack {
            Image("trainSMARTLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding(.bottom, 40)
            
            Text("")
                .font(.headline)
                .padding(.bottom, 20)
            
            TextField("Full Name", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
            
            TextField("Email Address", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
            
            TextField("Phone Number", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
            
            SecureField("Password", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
            
            SecureField("Confirm Password", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 20)
            
            Button("Register") {
                
            }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.horizontal)
            
            Spacer()
            
            NavigationLink(destination: LoginScreen(userData: userdata)) {
                Text("Already have an account? Login")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}


#Preview {
    RegisterScreen()
}
