//
//  HomeView.swift
//  trainSMART
//
//  Created by Jugad Singh on 12/24/24.
//

import SwiftUI

struct HomeScreen: View {
    private let quoteText = " "
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
                
                
                HStack {
                    Text("This Week...")
                        .padding(.leading, 40)
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Text("See More")
                            .foregroundColor(.black)
                            .padding(10)
                            .font(.system(size: 12))
                            .background(Color("Brand Color OffWhite"))
                            .cornerRadius(8)
                    }
                    .padding(.trailing, 40)
                }
                .padding(.top, 140)
                .padding(.bottom, 5)
                
                
                HStack {
                    VStack {
                        Text("Days Trained")
                            .foregroundColor(Color("Blue-gray"))
                            .font(.system(size: 20))
                            .padding(.bottom, 5)
                        Text("3")
                            .font(.system(size: 30))
                            .foregroundColor(Color("Green"))
                    }
                    .padding(.leading, 60)
                    Spacer()
                    VStack {
                        Text("Hours Trained")
                            .foregroundColor(Color("Blue-gray"))
                            .font(.system(size: 20))
                            .padding(.bottom, 5)
                        Text("4.5")
                            .font(.system(size: 30))
                            .foregroundColor(.red)
                    }
                    .padding(.trailing, 60)
                    
                }
                .padding(.bottom, 20)
                
                
                HStack {
                    Text("Training")
                        .padding(.leading, 80)
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Text("View All")
                            .foregroundColor(.black)
                            .padding(10)
                            .font(.system(size: 12))
                            .background(Color("Brand Color OffWhite"))
                            .cornerRadius(8)
                    }
                    .padding(.trailing, 80)
                }
                .padding(.bottom, 8)
                
                
                ZStack {
                    Image("field-image") // Replace with your stadium image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            VStack {
                                Image(systemName: "timer")
                                Text("~20 Minutes")
                                    .font(.system(size: 14))
                            }
                            .foregroundColor(.black)
                            .padding(.leading)
                            .padding(.top)
                            .padding(.bottom)
                            Spacer()
                            Text("Ball, Cones, Goal")
                                .padding()
                                .font(.system(size: 15))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal)
                        
                        .frame(width: 330)
                        .background(Color.white) // Add white background
                        .cornerRadius(15) // Add rounded corners to the background
                    }
                    .padding(.horizontal)
                    .padding(.top, 150)
                    .frame(alignment: .bottom)
                }
                .padding(.bottom)
                VStack {
                    HStack {
//                        Text("\"\(quoteText)\"")
//                            .foregroundColor(.white)
//                            .font(.custom(
//                                    "Book Antiqua",
//                                    fixedSize: 36))
                        Image(systemName: "quote.bubble")
                            .padding()
                            .font(.system(size: 25))
                        Spacer()
                        Text("Kevin De Bruyne")
                            .padding()
                    }
                    Text("A life of anybody is not perfect; there is always things that happen, and that is what makes it interesting.")
                        .padding()
                }
                .background(Color("Blue-gray"))
                .cornerRadius(15)
                .frame(width: 330)
                
                Spacer()
            }
            .background(Color("Brand Color Blue"))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    HomeScreen()
}
