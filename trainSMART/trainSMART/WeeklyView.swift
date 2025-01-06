//
//  WeeklyView.swift
//  trainSMART
//
//  Created by Jugad Singh on 12/31/24.
//

import SwiftUI

struct DayData: Identifiable {
    let id = UUID()
    let dayInitial: String
    let dayName: String
    let minutesSpent: Int
    let drills: Int
    let rating: Int
}
func getRating(_ rating: Int) -> Color {
    let baseOpacity = Double(rating) / 5.0 // Opacity scales with the rating
    switch rating {
    case 0:
        return Color.red.opacity(0.7)
    case 1...2:
        return Color("Orange").opacity(baseOpacity)
    case 3:
        return Color.yellow.opacity(baseOpacity)
    case 4...5:
        return Color.green.opacity(baseOpacity)
    default:
        return Color.gray
    }
}
struct WeeklyScreen: View {
    let days = [
        DayData(dayInitial: "M", dayName: "Monday", minutesSpent: 40, drills: 4, rating: 5),
        DayData(dayInitial: "T", dayName: "Tuesday", minutesSpent: 0, drills: 0, rating: 0),
        DayData(dayInitial: "W", dayName: "Wednesday", minutesSpent: 60, drills: 7, rating: 5),
        DayData(dayInitial: "T", dayName: "Thursday", minutesSpent: 20, drills: 1, rating: 2),
        DayData(dayInitial: "F", dayName: "Friday", minutesSpent: 30, drills: 2, rating: 3),
        DayData(dayInitial: "S", dayName: "Saturday", minutesSpent: 80, drills: 7, rating: 5)
    ]
    @State var goToDetails = false
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
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            HStack {
                                Text("This week...")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color("Brand Color OffWhite"))
                                    .padding()
                                Spacer()
                                Button(action: {
                                    goToDetails = true
                                }) {
                                    Text("More")
                                        .font(.subheadline)
                                        .foregroundStyle(Color.black)
                                        .padding()
                                }
                                .background(Color("Brand Color OffWhite"))
                                .cornerRadius(15)
                                .padding()
                                .navigationDestination(isPresented: $goToDetails) {
                                    DetailedStatsScreen()
                                }
                            }
                            .padding(.top)
                            
                            // Days list
                            ForEach(days) { day in
                                HStack {
                                    VStack {
                                        Text(day.dayInitial)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Text(day.dayName)
                                            .font(.caption)
                                            .foregroundColor(.black)
                                    }
                                    .frame(width: 100, height: 70) // Ensure all VStacks are the same size
                                    .background(Color("Lavender"))
                                    .cornerRadius(13)
                                    
                                    
                                    Spacer()
                                    HStack {
                                        VStack {
                                            Text(String(day.minutesSpent))
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            Text("Time Spent")
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }
                                        .frame(width: 70, height: 70) // Ensure all VStacks are the same size
                                        .background(Color("Brand Color OffWhite"))
                                        .cornerRadius(13)
                                        VStack {
                                            Text(String(day.drills))
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            Text("Drills Done")
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }
                                        .frame(width: 70, height: 70) // Ensure all VStacks are the same size
                                        .background(Color("Brand Color OffWhite"))
                                        .cornerRadius(13)
                                        VStack {
                                            Text(String(day.rating)+"/5")
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            Text("Rating")
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }
                                        .frame(width: 70, height: 70) // Ensure all VStacks are the same size
                                        .background(getRating(day.rating))
                                        .cornerRadius(13)
                                    }
                                }
                                .padding(.horizontal)
                                .padding()
                            }
                            .padding(.bottom, 20)
                            // Ensure spacing between content and the bottom
                        }
                    }
                    .background(Color("Brand Color Blue"))
                }
                .edgesIgnoringSafeArea(.top)
                
            }
        }
        .tint(Color("Dark blue"))

//        func getRating(_ rating: Int) -> Color {
//            switch rating {
//            case 0:
//                return Color.red.opacity(0.7)
//            case 1...2:
//                return Color.orange.opacity(0.7)
//            case 3:
//                return Color.yellow.opacity(0.7)
//            case 4...5:
//                return Color.green.opacity(0.7)
//            default:
//                return Color.gray
//            }
//        }
    }
}
#Preview {
    WeeklyScreen()
}
