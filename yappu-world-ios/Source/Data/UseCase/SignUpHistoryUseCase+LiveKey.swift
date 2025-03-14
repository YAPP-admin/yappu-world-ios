//
//  SignUpHistoryUseCase+LiveKey.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Foundation

import Dependencies

extension SignUpHistoryUseCase: DependencyKey {
    static var liveValue: SignUpHistoryUseCase = {
        @Dependency(AuthRepository.self)
        var authRepository
        @Dependency(FirebaseRepository.self)
        var firebaseRepository
        @Dependency(NotificationRepository.self)
        var notificationRepository
        
        return SignUpHistoryUseCase(
            fetchSignUp: authRepository.fetchSignUp,
            fetchFCMToken: firebaseRepository.fetchFCMToken,
            getAuthorizationStatus: notificationRepository.getAuthorizationStatus
        )
    }()
}
