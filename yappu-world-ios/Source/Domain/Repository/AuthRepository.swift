//
//  AuthRepository.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct AuthRepository {
    var fetchSignUp: @Sendable (
        _ model: SignUpInfoEntity
    ) async throws -> Bool
    var fetchCheckEmail: @Sendable (
        _ email: String
    ) async throws -> Bool
}

extension AuthRepository: TestDependencyKey {
    static var testValue: AuthRepository = {
        return AuthRepository(
            // TODO: 이곳에서 모킹
            fetchSignUp: { _ in return true },
            fetchCheckEmail: { _ in return true }
        )
    }()
}
