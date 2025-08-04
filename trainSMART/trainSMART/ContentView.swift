import SwiftUI
import FirebaseAuth
struct ContentView: View {
    @State private var showSplashScreen = true // State to control the splash screen
    @State private var selectedTab = 0
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
             if Auth.auth().currentUser != nil {
                 MainTabView() // Show the main content with TabView
             } else {
                LoginScreen() // Show the login screen if the user is not logged in
             }
        }
    }
}
struct MainTabView: View {
    init() {
        // Customize the Tab Bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "Dark blue")
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(.white)
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "Blue-gray")
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }


    var body: some View {
        TabView() {
            NavigationView {
                HomeScreen()
            }
            .tabItem {
                Image(systemName: "house")
                    .frame(width: 20, height: 20)
            }
            .tag(0)

            NavigationView {
                WeeklyScreen()
            }
            .tabItem {
                Image(systemName: "calendar")
                    .frame(width: 20, height: 20)
            }
            .tag(1)

            NavigationView {
                NewTrainingScreen()
            }
            .tabItem {
                Image(systemName: "plus.app.fill")
                    .frame(width: 20, height: 20)
            }
            .tag(2)

            NavigationView {
                CatalogScreen()
            }
            .tabItem {
                Image(systemName: "figure.indoor.soccer")
                    .frame(width: 20, height: 20)
            }
            .tag(3)

            NavigationView {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person")
                    .frame(width: 20, height: 20)
            }
            .tag(4)
        }
    }
}
