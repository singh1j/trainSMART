//
//  GlobalVariables.swift
//  trainSMART
//
//  Created by Jugad Singh on 1/8/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
let userDB = Firestore.firestore().collection("users")
let userID = Auth.auth().currentUser?.email
func getData(data: String, completion: @escaping (String) -> Void) {
    guard let userID = Auth.auth().currentUser?.email else {
        completion("")
        return
    }
    
    let docRef = userDB.document(userID)
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let value = document.data()?[data] as? String ?? ""
            completion(value)
        } else {
            completion("")
        }
    }
}

// Add this function to check and reset weekly stats
func checkAndResetWeeklyStats() {
    guard let userEmail = Auth.auth().currentUser?.email else { return }
    
    let db = userDB.document(userEmail)
    
    // Get the last reset timestamp
    db.getDocument { (document, error) in
        if let document = document, document.exists {
            let lastReset = document.data()?["last_weekly_reset"] as? Timestamp ?? Timestamp(date: Date())
            
            let calendar = Calendar.current
            let now = Date()
            let today = calendar.component(.weekday, from: now) // 1 = Sunday, 2 = Monday, etc.
            
            // If it's Sunday (weekday = 1) and we haven't reset today
            if today == 1 && !calendar.isDate(lastReset.dateValue(), inSameDayAs: now) {
                print("📅 It's Sunday! Resetting weekly stats...")
                
                // Reset all daily documents to 0
                let daysOfWeek = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
                
                for day in daysOfWeek {
                    db.collection("daily").document(day).setData([
                        "minutes": 0,
                        "drills": 0,
                        "rating": 0,
                        "completed": false,
                        "timestamp": Timestamp(date: now)
                    ])
                }
                
                // Update the last reset timestamp and reset weekly totals
                db.setData([
                    "last_weekly_reset": Timestamp(date: now),
                    "days-trained": "0",
                    "hours-this-week": "0"
                ], merge: true)
            }
        }
    }
}
