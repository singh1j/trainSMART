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

import SwiftUI

struct MainTabView: View {
    init() {
        // Customize the Tab Bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "Dark blue") // Use your custom color
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(.white) // Customize icon color
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "Blue-gray") // Customize selected icon color
        
        // Apply the appearance
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance // For iOS 15+
    }

    var body: some View {
        TabView {
            NavigationView {
                HomeScreen()
            }
            .tabItem {
                Image(systemName: "house")
            }

            NavigationView {
                WeeklyScreen()
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
                CatalogScreen()
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
