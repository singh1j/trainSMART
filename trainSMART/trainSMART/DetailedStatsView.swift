//
//  DetailedStatsView.swift
//  trainSMART
//
//  Created by Jugad Singh on 1/1/25.
//

import SwiftUI

struct DetailedStatsScreen: View {
    @State var goBack = false
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
                    // Ensure spacing between content and the bottom
                    ScrollView {
                        VStack {
                            HStack {
                                Text("Your Weekly Goals")
                                    .font(.title3)
                                    .foregroundStyle(Color("Brand Color OffWhite"))
                                    .padding()
                                Spacer()
                                Button(action: {
                                    
                                }) {
                                    Text("Change Goals")
                                        .font(.subheadline)
                                        .foregroundStyle(Color.black)
                                        .padding()
                                }
                                .background(Color("Brand Color OffWhite"))
                                .cornerRadius(15)
                                .padding()
                            }
                            HStack {
                                Spacer()
                                VStack {
                                    Text("5")
                                        .font(.title3)
                                        .foregroundColor(.black)
                                    Text("Days/Week")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 100, height: 100) // Ensure all VStacks are the same size
                                .background(Color("Brand Color OffWhite"))
                                .cornerRadius(13)
                                .padding()
                                Spacer()
                                VStack {
                                    Text("10")
                                        .font(.title3)
                                        .foregroundColor(.black)
                                    Text("Hours/Week")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 100, height: 100) // Ensure all VStacks are the same size
                                .background(Color("Brand Color OffWhite"))
                                .cornerRadius(13)
                                .padding()
                                Spacer()
                            }
                        }
                        .padding(.bottom)
                        VStack {
                            HStack {
                                Text("This week...")
                                    .font(.title3)
                                    .foregroundStyle(Color("Brand Color OffWhite"))
                                    .padding()
                                Spacer()
                                Button(action: {
                                    goBack = true
                                }) {
                                    Text("Details")
                                        .font(.subheadline)
                                        .foregroundStyle(Color.black)
                                        .padding()
                                }
                                .background(Color("Brand Color OffWhite"))
                                .cornerRadius(15)
                                .padding()
                                .navigationDestination(isPresented: $goBack) {
                                    WeeklyScreen()
                                }
                            }
                            HStack {
                                Spacer()
                                VStack {
                                    Text("3")
                                        .font(.title3)
                                        .foregroundColor(.black)
                                    Text("Days")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 100, height: 100) // Ensure all VStacks are the same size
                                .background(Color("Lavender"))
                                .cornerRadius(13)
                                .padding()
                                Spacer()
                                VStack {
                                    Text("3")
                                        .font(.title3)
                                        .foregroundColor(.black)
                                    Text("Hours")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 100, height: 100) // Ensure all VStacks are the same size
                                .background(Color("Lavender"))
                                .cornerRadius(13)
                                .padding()
                                Spacer()
                            }
                        }
                        .padding(.bottom)
                        VStack {
                            HStack {
                                Text("Lifetime Stats...")
                                    .font(.title3)
                                    .foregroundStyle(Color("Brand Color OffWhite"))
                                    .padding()
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                VStack {
                                    Text("100")
                                        .font(.title3)
                                        .foregroundColor(.black)
                                    Text("Days")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 100, height: 100) // Ensure all VStacks are the same size
                                .background(Color("Brown"))
                                .cornerRadius(13)
                                .padding()
                                Spacer()
                                VStack {
                                    Text("300")
                                        .font(.title3)
                                        .foregroundColor(.black)
                                    Text("Hours")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 100, height: 100) // Ensure all VStacks are the same size
                                .background(Color("Brown"))
                                .cornerRadius(13)
                                .padding()
                                Spacer()
                            }
                        }
                        .padding(.bottom)
                        
                    }
                    .background(Color("Brand Color Blue"))
                }
                .background(Color("Brand Color Blue"))
            }
            .tint(Color("Dark blue"))
            .edgesIgnoringSafeArea(.top)
        }
    }
}
#Preview {
    DetailedStatsScreen()
}
