//
//  CatalogView.swift
//  trainSMART
//
//  Created by Jugad Singh on 12/29/24.
//

import SwiftUI

struct CatalogScreen: View {
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                // Logo section with adjusted size and no unnecessary space
                ZStack {
                    Color("Brand Color OffWhite")
                        .frame(height: 150) // Reduced height of the logo section
                    Image("trainSMARTLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150) // Adjusted logo height
                        .padding(.top, 20) // Adjust top padding to place logo correctly
                }
                .frame(height: 150)
            }
            Text("Training Categories")
                .font(.system(size: 25))
                .foregroundStyle(Color("Brand Color OffWhite"))
                .padding(.top, 10)
            Spacer()
            
        }
        .background(Color("Brand Color Blue"))
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    CatalogScreen()
}
