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
}

extension SplashUseCase: TestDependencyKey {
    static let testValue = {
        @Dependency(AuthRepository.self)
        var authRepository
        
        return SplashUseCase(
            reissueToken: authRepository.reissueToken
        )
    }()
}
