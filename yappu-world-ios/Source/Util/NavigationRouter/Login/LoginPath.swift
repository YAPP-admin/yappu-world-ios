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
    case email
    case password
    case history
    case complete(isComplete: Bool)
}
