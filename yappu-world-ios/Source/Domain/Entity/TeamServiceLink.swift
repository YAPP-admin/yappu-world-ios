//
//  TeamServiceLink.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation

enum TeamServiceLinkKind: String, Hashable, Codable, Sendable, CaseIterable {
    case appStore
    case playStore
    case web

    var displayName: String {
        switch self {
        case .appStore: "App Store"
        case .playStore: "Play Store"
        case .web: "Web"
        }
    }
}

struct TeamServiceLink: Hashable, Sendable {
    let kind: TeamServiceLinkKind
    let url: URL
}
