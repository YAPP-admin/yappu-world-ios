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
    case All
    
    var text: String {
        switch self {
        case .All:
            return "전체"
        case .Player:
            return "활동회원"
        case .Certificated:
            return "정회원"
        }
    }
    
    static func convert(text: String) -> Self? {
        switch text {
        case "전체":
            return .All
        case "활동회원":
            return .Player
        case "정회원":
            return .Certificated
        default: return nil
        }
    }
}
