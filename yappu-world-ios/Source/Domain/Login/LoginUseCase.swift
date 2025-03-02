//
//  LoginUseCase.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/28/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct LoginUseCase {
    var fetchLogin: (
        _ model: LoginEntity
    ) async throws -> Bool
}

extension LoginUseCase: TestDependencyKey {
    static var testValue = {
        @Dependency(AuthRepository.self)
        var authRepository
        
        return LoginUseCase(
            fetchLogin: authRepository.fetchLogin
        )
    }()
}
