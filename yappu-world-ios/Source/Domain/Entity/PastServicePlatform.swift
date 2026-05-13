//
//  PastServicePlatform.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation

enum PastServicePlatform: String, Hashable, Codable, Sendable, CaseIterable {
    case app = "App"
    case web = "Web"

    var displayName: String { rawValue }
}
