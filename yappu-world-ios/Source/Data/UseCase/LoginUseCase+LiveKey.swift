//
//  LoginUseCase+LiveKey.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/28/25.
//

import Foundation

import Dependencies

extension LoginUseCase: DependencyKey {
    static let liveValue = {
        @Dependency(AuthRepository.self)
        var authRepository
        
        return LoginUseCase(fetchLogin: authRepository.fetchLogin)
    }()
}
