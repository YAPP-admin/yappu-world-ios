//
//  AppDelegate.swift
//  yappu-world-ios
//
//  Created by 김도형 on 3/3/25.
//

import SwiftUI

import Dependencies
import FirebaseMessaging
import Firebase

final class AppDelegate: NSObject, UIApplicationDelegate {
    @Dependency(FirebaseRepository.self)
    private var firebaseRepository
    @Dependency(NotificationRepository.self)
    private var notificationRepository
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        firebaseRepository.configureFirebase()
        
        notificationRepository.requestAuthorization(application: application)

        return true
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        firebaseRepository.updateAPNSToken(deviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print("fail: \(#function) -> \(error)")
    }
}
