//
//  LogDrillView.swift
//  trainSMART
//
//  Created by Jugad Singh on 12/31/24.
//

import SwiftUI

struct LogDrillScreen: View {
    @State var time: Int
    @State var go = false
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Color("Brand Color OffWhite")
                        .frame(height: 150) // Fixed height for the logo section
                    Image("trainSMARTLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150) // Adjusted logo height
                        .padding(.top, 20) // Adjust top padding to place logo correctly
                }
                .frame(height: 150)
                Text("How much time did you spend?")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .padding()
                TextField("-- Minutes", value: $time, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundStyle(Color.white)
                    .keyboardType(.decimalPad) // Numeric keyboard
                    .padding()
                Button(action: {
                    // Button action here
                    go = true
                }) {
                    Text("Log")
                        .foregroundStyle(Color.white)
                        .padding()
                }
                .background(Color("Dark blue"))
                .cornerRadius(10)
                .fullScreenCover(isPresented: $go) {
                    MainTabView()
                }
                Spacer()
            }
            .background(Color("Brand Color Blue"))
            .edgesIgnoringSafeArea(.top)
        }
    }
}

#Preview {
    LogDrillScreen(time: 0)
}
