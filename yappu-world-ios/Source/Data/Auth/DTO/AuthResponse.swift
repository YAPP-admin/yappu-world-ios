//
//  SignUpResponse.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Foundation

struct AuthResponse: Decodable {
    let isSuccess: Bool
    let data: AuthToken?
}
