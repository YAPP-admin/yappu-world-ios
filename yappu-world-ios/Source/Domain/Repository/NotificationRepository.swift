//
//  NotificationRepository.swift
//  yappu-world-ios
//
//  Created by 김도형 on 3/3/25.
//

import SwiftUI
import UserNotifications
import Combine

import Dependencies
import DependenciesMacros

@DependencyClient
struct NotificationRepository {
    var requestAuthorization: (
        _ application: UIApplication
    ) -> Void
    var userInfoPublisher: () -> AnyPublisher<NotificationEntity?, Never> = {
        .init(Empty())
    }
    var getAuthorizationStatus: () async -> Bool = { false }
}

extension NotificationRepository: TestDependencyKey {
    static var testValue = {
        return NotificationRepository(
            requestAuthorization: { _ in },
            userInfoPublisher: { AnyPublisher(Empty()) },
            getAuthorizationStatus: { true }
        )
    }()
}
