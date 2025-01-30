//
//  AuthRepository+LiveKey.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Foundation

import Dependencies

extension AuthRepository: DependencyKey {
    static var liveValue: AuthRepository = {
        // TODO: 이곳에 실제 네트워크 구현체 선언
        /// ex) `let provider = NetworkProvider()`
        
        return AuthRepository(
            fetchSignUp: { model in
                let request = model.toData()
                /// ex)
                /// `try await provider.request(request)`
                return true
            }
        )
    }()
}
