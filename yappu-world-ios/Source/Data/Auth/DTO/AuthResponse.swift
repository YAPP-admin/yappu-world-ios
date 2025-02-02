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

extension AuthResponse {
    func toEntity() -> SignUpEntity {
        return SignUpEntity(
            isSuccess: self.isSuccess,
            isComplete: self.data != nil
        )
    }
}
