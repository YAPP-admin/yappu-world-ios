//
//  SignUpEmailUseCase+LiveKey.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/2/25.
//

import Foundation

import Dependencies

extension SignUpEmailUseCase: DependencyKey {
    static var liveValue: SignUpEmailUseCase = {
        @Dependency(AuthRepository.self)
        var authRepository
        
        return SignUpEmailUseCase(
            fetchCheckEmail: authRepository.fetchCheckEmail
        )
    }()
}
