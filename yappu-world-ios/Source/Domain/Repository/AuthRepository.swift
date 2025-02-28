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
    ) async throws -> SignUpEntity
    var fetchCheckEmail: @Sendable (
        _ email: String
    ) async throws -> Bool
    var fetchLogin: @Sendable (
        _ model: LoginEntity
    ) async throws -> Bool
    var deleteUser: @Sendable () async throws -> Void
    var reissueToken: @Sendable () async throws -> Bool
}

extension AuthRepository: TestDependencyKey {
    static var testValue: AuthRepository = {
        return AuthRepository(
            // TODO: 이곳에서 모킹
            fetchSignUp: { _ in return .mock },
            fetchCheckEmail: { _ in return true },
            fetchLogin: { _ in return true },
            deleteUser: { },
            reissueToken: { return true }
        )
    }()
}
