//
//  NotificationRepository.swift
//  yappu-world-ios
//
//  Created by 김도형 on 3/3/25.
//

import Foundation
import UIKit

import Dependencies
import DependenciesMacros

@DependencyClient
struct NotificationRepository {
    var requestAuthorization: (
        _ application: UIApplication
    ) -> Void
    var userInfoPublisher: () -> AsyncStream<[AnyHashable: Any]> = {
        return AsyncStream { $0.finish() }
    }
}

extension NotificationRepository: TestDependencyKey {
    static var testValue = {
        return NotificationRepository(
            requestAuthorization: { _ in },
            userInfoPublisher: { AsyncStream { $0.finish() } }
        )
    }()
}
