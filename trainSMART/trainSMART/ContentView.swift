import SwiftUI

struct ContentView: View {
    @State private var showSplashScreen = true // State to control the splash screen

    var body: some View {
        if showSplashScreen {
            SplashScreen()
                .onAppear {
                    // Automatically hide the splash screen after a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showSplashScreen = false
                        }
                    }
                }
        } else {
            MainTabView() // Show the main content with TabView
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                HomeScreen()
            }
            .tabItem {
                Image(systemName: "house")
            }

            NavigationView {
                HomeScreen()
            }
            .tabItem {
                Image(systemName: "calendar")
            }

            NavigationView {
                HomeScreen()
            }
            .tabItem {
                Image(systemName: "sportscourt")
            }

            NavigationView {
                HomeScreen()
            }
            .tabItem {
                Image(systemName: "figure.walk")
            }

            NavigationView {
                HomeScreen()
            }
            .tabItem {
                Image(systemName: "person")
            }
        }
    }
}

