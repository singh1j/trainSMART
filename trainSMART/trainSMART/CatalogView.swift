//
//  CatalogView.swift
//  trainSMART
//
//  Created by Jugad Singh on 12/29/24.
//

import SwiftUI

struct Category: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
}

import SwiftUI

struct CatalogScreen: View {
    let categories = [
        Category(title: "Goalkeeping", icon: "hand.raised"),
        Category(title: "Defending", icon: "shield"),
        Category(title: "Touch/Control", icon: "arrow.up.arrow.down"),
        Category(title: "Shooting", icon: "scope"),
        Category(title: "Passing", icon: "soccerball"),
        Category(title: "Dribbling", icon: "figure.run")
    ]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Logo section with adjusted size
                    ZStack {
                        Color("Brand Color OffWhite")
                            .frame(height: 150) // Fixed height for the logo section
                        Image("trainSMARTLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150) // Adjusted logo height
                            .padding(.top, 20) // Adjust top padding to place logo correctly
                    }
                    .frame(height: 150) // Ensures the logo section height is consistent
                    
                    // ScrollView for training categories
                    ScrollView {
                        VStack(spacing: 10) {
                            Text("Training Categories")
                                .font(.system(size: 25))
                                .foregroundColor(Color("Brand Color OffWhite"))
                                .padding(.top, 10)
                                .padding(.bottom)
                            
                            // Categories list
                            ForEach(categories) { category in
                                NavigationLink(destination: DrillCatScreen(skill: category.title)) {
                                    HStack {
                                        // Title text
                                        Text(category.title)
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            .padding()
                                        
                                        // Icon
                                        Image(systemName: category.icon)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.black)
                                            .padding(.horizontal)
                                        
                                        // Text label instead of button
                                        Text("View Category")
                                            .foregroundColor(.black)
                                            .font(.caption)
                                            .padding()
                                            .background(.white)
                                            .cornerRadius(15)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                                            .padding()
                                    }
                                    .frame(height: 70)
                                    .background(Color("Lavender"))
                                    .cornerRadius(10)
                                    .padding(.bottom)
                                }
                            }
                            .padding(.horizontal)

                        }
                        .padding(.bottom, 10) // Ensure spacing between content and the bottom
                    }
//                    .frame(height: geometry.size.height - 150) // Calculate height dynamically based on available space
                }
                .background(Color("Brand Color Blue"))
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}


#Preview {
    CatalogScreen()
}
