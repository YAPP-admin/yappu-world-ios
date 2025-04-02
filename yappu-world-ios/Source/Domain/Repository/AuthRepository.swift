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
    var fetchSignUp: (
        _ model: SignUpInfoEntity
    ) async throws -> SignUpEntity
    var fetchCheckEmail: (
        _ email: String
    ) async throws -> CheckEmailResponse
    var fetchLogin: (
        _ model: LoginEntity
    ) async throws -> Bool
    var deleteUser: () async throws -> Void
    var reissueToken: () async throws -> Bool
    var deleteToken: () async throws -> Void
}

extension AuthRepository: TestDependencyKey {
    static var testValue: AuthRepository = {
        return AuthRepository(
            // TODO: 이곳에서 모킹
            fetchSignUp: { _ in return .mock },
            fetchCheckEmail: { _ in return CheckEmailResponse(message: "", isSuccess: true, errorCode: nil) },
            fetchLogin: { _ in return true },
            deleteUser: { },
            reissueToken: { return true },
            deleteToken: { }
        )
    }()
}
