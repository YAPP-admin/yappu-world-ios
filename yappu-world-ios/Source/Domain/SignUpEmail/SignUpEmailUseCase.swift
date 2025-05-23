//
//  SignUpEmailUseCase.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/2/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct SignUpEmailUseCase {
    var fetchCheckEmail: (
        _ model: String
    ) async throws -> CheckEmailResponse
}

extension SignUpEmailUseCase: TestDependencyKey {
    static var testValue: SignUpEmailUseCase = {
        @Dependency(AuthRepository.self)
        var authRepository
        
        return SignUpEmailUseCase(
            fetchCheckEmail: authRepository.fetchCheckEmail
        )
    }()
}
