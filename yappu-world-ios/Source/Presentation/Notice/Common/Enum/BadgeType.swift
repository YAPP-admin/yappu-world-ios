//
//  BadgeType.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/23/25.
//

import Foundation

enum BadgeType: Codable {
    case Notice
    case Session
    
    var text: String {
        switch self {
        case .Notice:
            return "운영"
        case .Session:
            return "세션"
        }
    }
    
    static func convert(text: String) -> Self? {
        switch text {
        case "SESSION": return .Session
        case "OPERATION": return .Notice
        default: return nil
        }
    }
}
