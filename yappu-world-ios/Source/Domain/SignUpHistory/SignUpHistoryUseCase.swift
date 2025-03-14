//
//  SignUpHistoryUseCase.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct SignUpHistoryUseCase {
    var fetchSignUp: (
        _ model: SignUpInfoEntity
    ) async throws -> SignUpEntity
    var fetchFCMToken: () async throws -> String
    var getAuthorizationStatus: () async -> Bool = { false }
}

extension SignUpHistoryUseCase: TestDependencyKey {
    static var testValue: SignUpHistoryUseCase = {
        @Dependency(AuthRepository.self)
        var authRepository
        @Dependency(FirebaseRepository.self)
        var firebaseRepository
        
        return SignUpHistoryUseCase(
            fetchSignUp: authRepository.fetchSignUp,
            fetchFCMToken: firebaseRepository.fetchFCMToken,
            getAuthorizationStatus: { true }
        )
    }()
}
