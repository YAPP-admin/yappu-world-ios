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
    private let userInfoSubject = CurrentValueSubject<NotificationResponse?, Never>(nil)
    
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
    
    func userInfoPublisher() -> AnyPublisher<NotificationResponse?, Never> {
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
        guard let aps = userInfo["aps"] else { return }
        let jsonData = try? JSONSerialization.data(
            withJSONObject: aps,
            options: []
        )
        guard let jsonData else { return }
        
        let notification = try? JSONDecoder().decode(
            NotificationResponse.self,
            from: jsonData
        )
        userInfoSubject.send(notification)
        
        completionHandler()
    }
}
