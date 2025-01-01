//
//  DrillView.swift
//  trainSMART
//
//  Created by Jugad Singh on 12/31/24.
//

import SwiftUI
import YouTubePlayerKit

struct DrillScreen: View {
    @State var goToLog = false
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
                    .frame(height: 150)
                    .padding(.bottom)
                ScrollView {
                    Text("Drill Name")
                        .font(.title)
                        .foregroundStyle(Color.white)
                    YouTubePlayerView(
                        "https://www.youtube.com/watch?v=H73tNVmfqlM&pp=ygUIbWFuIGNpdHk%3D"
                    )
                    .aspectRatio(16/9, contentMode: .fit)
                    HStack {
                        VStack {
                            Text("Name of Drill")
                            HStack {
                                Image(systemName: "soccerball")
                                Text("Ball, Cones, Goal, 1/4 Field")
                                    .font(.caption)
                            }
                        }
                        .padding()
                        Spacer()
                        VStack {
                            Image(systemName: "timer")
                                .font(.title)
                            Text("20 Minutes")
                                .font(.headline)
                        }
                        .padding()
                        Spacer()
                        Image(systemName: "scope")
                            .font(.title)
                            .padding()
                            
                    }
                    .background(Color("Dark blue"))
                    .cornerRadius(15)
                    .padding()
                    HStack {
                        VStack {
                            Text("3")
                                .font(.title)
                                .padding(.top)
                                .foregroundStyle(Color.black)
                            Text("Difficulty")
                                .font(.caption)
                                .foregroundStyle(Color.black)

                                .padding(.bottom)
                                .padding(.leading)
                                .padding(.trailing)
                        }
                        .background(Color.yellow)
                        .cornerRadius(15)
                        .padding()
                        Spacer()
                        VStack {
                            Text("20")
                                .font(.title)
                                .foregroundStyle(Color.black)
                                .padding(.top)

                            Text("Rec. Time")
                                .font(.caption)
                                .foregroundStyle(Color.black)
                                .padding(.bottom)
                                .padding(.leading)
                                .padding(.trailing)
                        }
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding()
                        Spacer()
                        VStack {
                            Text("1/4")
                                .font(.title)
                                .foregroundStyle(Color.black)
                                .padding(.top)

                            Text("Field Req.")
                                .font(.caption)
                                .foregroundStyle(Color.black)
                                .padding(.bottom)
                                .padding(.leading)
                                .padding(.trailing)

                        }
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding()
                    }
                    Text("Lorem Ipsum is simply dummy text of the printing and  typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Categories")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top)
                            .padding(.bottom, 10)
                        Text("Forward, Midfielder, Defender")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Text("Passing, Shooting")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.bottom)
                        Button(action: {
                            // Button action here
                            goToLog = true
                        }) {
                            Text("Log This")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .background(Color("Dark blue"))
                        .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Aligns everything in the VStack to the left
                    .padding()
                    .navigationDestination(isPresented: $goToLog) {
                        LogDrillScreen(time: 0)
                    }

                }
//                .frame(height: geometry.size.height)
                }
                .background(Color("Brand Color Blue"))
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

#Preview {
    DrillScreen()
}
