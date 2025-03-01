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
}

extension SignUpHistoryUseCase: TestDependencyKey {
    static var testValue: SignUpHistoryUseCase = {
        @Dependency(AuthRepository.self)
        var authRepository
        
        return SignUpHistoryUseCase(
            fetchSignUp: authRepository.fetchSignUp
        )
    }()
}
