//
//  SettingUseCase.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/28/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct SettingUseCase {
    var deleteUser: @Sendable () async throws ->  Void
}

extension SettingUseCase: TestDependencyKey {
    static let testValue = {
        @Dependency(AuthRepository.self)
        var authRepository
        
        return SettingUseCase(
            deleteUser: authRepository.deleteUser
        )
    }()
}
