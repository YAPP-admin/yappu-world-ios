//
//  SignUpHistoryUseCase+LiveKey.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Foundation

import Dependencies

extension SignUpHistoryUseCase: DependencyKey {
    static var liveValue: SignUpHistoryUseCase = {
        @Dependency(AuthRepository.self)
        var authRepository
        
        return SignUpHistoryUseCase(
            fetchSignUp: authRepository.fetchSignUp
        )
    }()
}
