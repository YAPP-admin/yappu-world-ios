//
//  SignUpEntity.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/2/25.
//

import Foundation

struct SignUpEntity {
    let isSuccess: Bool
    let isComplete: Bool
}

extension SignUpEntity {
    static let mock = SignUpEntity(isSuccess: true, isComplete: true)
}
