//
//  NotificationDataSource.swift
//  Data
//
//  Created by 김도형 on 9/17/24.
//

import SwiftUI
import Combine

import UserNotifications

final class NotificationManager: NSObject {
    private let userInfoSubject = CurrentValueSubject<[AnyHashable : Any], Never>([:])
    
    func requestAuthorization(
        _ application: UIApplication
    ) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
    }
    
    func userInfoPublisher() -> AnyPublisher<[AnyHashable : Any], Never> {
        return userInfoSubject.eraseToAnyPublisher()
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
        
        userInfoSubject.send(userInfo)
        
        completionHandler()
    }
}
