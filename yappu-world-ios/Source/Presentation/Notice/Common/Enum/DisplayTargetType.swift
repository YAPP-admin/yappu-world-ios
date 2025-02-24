//
//  DisplayTargetType.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/23/25.
//

import Foundation

enum DisplayTargetType: Codable {
    case Player
    case Certificated
    
    var text: String {
        switch self {
        case .Player:
            return "활동회원"
        case .Certificated:
            return "정회원"
        }
    }
    
    static func convert(text: String) -> Self? {
        switch text {
        case "활동회원":
            return .Player
        case "정회원":
            return .Certificated
        default: return nil
        }
    }
}
