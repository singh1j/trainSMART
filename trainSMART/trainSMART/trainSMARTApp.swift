//
//  trainSMARTApp.swift
//  trainSMART
//
//  Created by Jugad Singh on 12/23/24.
//

import SwiftUI
import Firebase

@main
struct trainSMARTApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn = false    
    init() {
        FirebaseApp.configure()
        NotificationManager.instance.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView()
                    .onAppear {
                        checkAndResetWeeklyStats()
                    }
            } else {
                LoginScreen()
            }
        }
    }
}
