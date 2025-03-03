//
//  FirebaseRepository.swift
//  yappu-world-ios
//
//  Created by 김도형 on 3/3/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct FirebaseRepository {
    var configureFirebase: () -> Void
    var updateAPNSToken: (_ deviceToken: Data) -> Void
    var fetchFCMToken: () async -> String?
}

extension FirebaseRepository: TestDependencyKey {
    static var testValue = {
        return FirebaseRepository(
            configureFirebase: { },
            updateAPNSToken: { _ in },
            fetchFCMToken: { nil }
        )
    }()
}
