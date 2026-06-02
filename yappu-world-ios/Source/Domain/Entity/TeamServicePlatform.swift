//
//  TeamServicePlatform.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation

enum TeamServicePlatform: String, Hashable, Codable, Sendable, CaseIterable {
    case app = "App"
    case web = "Web"

    var displayName: String { rawValue }

    /// 목록 API 쿼리 파라미터 값 (platform 필터: APP/WEB)
    var apiValue: String {
        switch self {
        case .app: "APP"
        case .web: "WEB"
        }
    }

    /// 서버 응답의 hasApp/hasWeb 불리언을 플랫폼 배열로 변환
    static func from(hasApp: Bool, hasWeb: Bool) -> [TeamServicePlatform] {
        var result: [TeamServicePlatform] = []
        if hasApp { result.append(.app) }
        if hasWeb { result.append(.web) }
        return result
    }
}
