//
//  SignUpResponse.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Foundation

struct SignUpResponse: Decodable {
    let isSuccess: Bool
    let data: Token?
}

extension SignUpResponse {
    struct Token: Decodable {
        let accessToken: String
        let refreshToken: String
    }
}
