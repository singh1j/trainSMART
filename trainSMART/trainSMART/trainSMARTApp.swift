//
//  trainSMARTApp.swift
//  trainSMART
//
//  Created by Jugad Singh on 12/23/24.
//

import SwiftUI

@main
struct trainSMARTApp: App {
    @StateObject private var userData = UserData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userData)
            
        }
    }
}
