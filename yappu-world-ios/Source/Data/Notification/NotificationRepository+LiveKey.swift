//
//  NotificationRepository+LiveKey.swift
//  yappu-world-ios
//
//  Created by 김도형 on 3/3/25.
//

import Foundation

import Dependencies

extension NotificationRepository: DependencyKey {
    static var liveValue = {
        let manager = NotificationManager()
        
        return NotificationRepository(
            requestAuthorization: manager.requestAuthorization,
            userInfoPublisher: manager.userInfoPublisher,
            getAuthorizationStatus: {
                let status = await manager.getAuthorizationStatus()
                return status == .authorized
            }
        )
    }()
}
