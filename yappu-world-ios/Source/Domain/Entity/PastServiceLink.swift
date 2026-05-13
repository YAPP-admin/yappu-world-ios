//
//  PastServiceLink.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation

enum PastServiceLinkKind: String, Hashable, Codable, Sendable, CaseIterable {
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

struct PastServiceLink: Hashable, Sendable {
    let kind: PastServiceLinkKind
    let url: URL
}
