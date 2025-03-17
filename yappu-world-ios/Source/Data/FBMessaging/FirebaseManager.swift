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
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
    }
    
    func updateAPNSToken(_ deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func fetchFCMToken() async throws -> String {
        let fcmToken = try await Messaging.messaging().token()
        return fcmToken
    }
}

extension FirebaseManager: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        print("fcmToken: \(fcmToken)")
    }
}
