import SwiftUI

struct HomeScreen: View {
    private let quoteText = " "
    @State var goToCatalog = false
    @State var goToWeekly = false
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
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
                    .frame(height: 150) // Ensures the logo section is fixed at the top

                    // ScrollView for the rest of the content
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            // "This Week" Section
                            HStack {
                                Text("This Week...")
                                    .padding(.leading, 40)
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                                Spacer()
                                Button(action: {
                                    goToWeekly = true
                                }) {
                                    Text("See More")
                                        .foregroundColor(.black)
                                        .padding(10)
                                        .font(.system(size: 12))
                                        .background(Color("Brand Color OffWhite"))
                                        .cornerRadius(8)
                                }
                                .padding(.trailing, 40)
                                .navigationDestination(isPresented: $goToWeekly) {
                                    WeeklyScreen()
                                }
                            }
                            .padding(.top, 20) // Reduced top padding
                            .padding(.bottom, 15)
                            
                            // Days and Hours Trained Section
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
                            .padding(.bottom, 40)
                            
                            // Training Section
                            HStack {
                                Text("Training")
                                    .padding(.leading, 80)
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                                Spacer()
                                Button(action: {
                                    goToCatalog = true
                                }) {
                                    Text("View All")
                                        .foregroundColor(.black)
                                        .padding(10)
                                        .font(.system(size: 12))
                                        .background(Color("Brand Color OffWhite"))
                                        .cornerRadius(8)
                                }
                                .padding(.trailing, 80)
                                .navigationDestination(isPresented: $goToCatalog) {
                                    CatalogScreen()
                                }
                            }
                            .padding(.bottom)
                            
                            // Image Section with field image
                            NavigationLink (destination: DrillScreen()) {
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
                            }
                        
                            
                            // Quote Section
                            VStack {
                                HStack {
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
                            .padding(.bottom, 50)
                        }
                        .background(Color("Brand Color Blue"))
                        .padding(.top, 0)
                    }
                    .padding(.bottom, 0) // Remove extra padding at the bottom
                }
                .background(Color("Brand Color Blue"))
            }
            .edgesIgnoringSafeArea(.top) // Ensures the top of the screen is used without extra black space
        }
        .tint(Color("Dark blue"))
    }
}

#Preview {
    HomeScreen()
}
