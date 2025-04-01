//
//  LoginPath.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Foundation

import Dependencies

enum LoginPath: Hashable {
    case name
    case email(SignUpInfoEntity)
    case password(SignUpInfoEntity)
    case history(SignUpInfoEntity)
    case complete(isComplete: Bool)
    case safari(url: URL)
}
