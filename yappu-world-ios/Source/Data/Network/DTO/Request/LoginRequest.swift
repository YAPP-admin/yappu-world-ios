//
//  LoginRequest.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/2/25.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

extension LoginEntity {
    func toData() -> LoginRequest {
        return LoginRequest(email: email, password: password)
    }
}
