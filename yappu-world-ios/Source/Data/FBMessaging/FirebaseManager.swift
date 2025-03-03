//
//  FBMessagingDataSource.swift
//  Data
//
//  Created by 김도형 on 9/17/24.
//

import Foundation

import Firebase
import FirebaseMessaging


final class FirebaseManager: NSObject {
    func configureFirebase() {
        FirebaseApp.configure()
        Messaging.messaging().isAutoInitEnabled = true
    }
    
    func updateAPNSToken(_ deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func fetchFCMToken() async -> String? {
        let fcmToken = try? await Messaging.messaging().token()
        print("fcmToken: \(fcmToken)")
        return fcmToken
    }
}
