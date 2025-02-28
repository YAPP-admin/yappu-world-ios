//
//  SplashUseCase+LiveKey.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/28/25.
//

import Foundation

import Dependencies

extension SplashUseCase: DependencyKey {
    static var liveValue = {
        @Dependency(AuthRepository.self)
        var authRepository
        
        return SplashUseCase(
            reissueToken: authRepository.reissueToken
        )
    }()
}
