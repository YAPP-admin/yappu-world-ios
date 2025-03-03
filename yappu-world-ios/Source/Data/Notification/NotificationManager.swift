//
//  NotificationDataSource.swift
//  Data
//
//  Created by 김도형 on 9/17/24.
//

import SwiftUI

import UserNotifications

final class NotificationManager: NSObject {
    private var continuation: AsyncStream<[AnyHashable : Any]>.Continuation? {
        willSet { continuation?.finish() }
    }
    
    override init() {
        super.init()
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization(
        _ application: UIApplication
    ) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
    }
    
    func userInfoPublisher() -> AsyncStream<[AnyHashable : Any]> {
        return AsyncStream { [weak self] continuation in
            self?.continuation = continuation
        }
    }
    
    func getAuthorizationStatus() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        continuation?.yield(userInfo)
        
        completionHandler()
    }
}
