//
//  SplashUseCase.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/28/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct SplashUseCase {
    var reissueToken: () async throws -> Bool
    var loadProfile: @Sendable() async throws -> ProfileResponse
}

extension SplashUseCase: TestDependencyKey {
    static let testValue = {
        @Dependency(AuthRepository.self)
        var authRepository
        @Dependency(MyPageRepository.self)
        var myPageRepository
        
        return SplashUseCase(
            reissueToken: authRepository.reissueToken,
            loadProfile: myPageRepository.loadProfile
        )
    }()
}
