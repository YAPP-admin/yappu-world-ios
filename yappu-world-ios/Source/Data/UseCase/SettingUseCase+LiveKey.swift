//
//  SettingUseCase+LiveKey.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/28/25.
//

import Foundation

import Dependencies

extension SettingUseCase: DependencyKey {
    static var liveValue = {
        @Dependency(AuthRepository.self)
        var authRepository
        
        return SettingUseCase(
            deleteUser: authRepository.deleteUser,
            deleteToken: authRepository.deleteToken
        )
    }()
}
