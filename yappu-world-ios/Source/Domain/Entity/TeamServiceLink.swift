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

extension TeamServiceLink {
    /// 상세 응답의 스토어/웹 링크 문자열에서 유효한 링크만 추출 (nil·빈문자·잘못된 URL 제외)
    static func make(appStore: String?, playStore: String?, web: String?) -> [TeamServiceLink] {
        var links: [TeamServiceLink] = []
        func append(_ kind: TeamServiceLinkKind, _ raw: String?) {
            guard let raw, !raw.isEmpty, let url = URL(string: raw) else { return }
            links.append(.init(kind: kind, url: url))
        }
        append(.appStore, appStore)
        append(.playStore, playStore)
        append(.web, web)
        return links
    }
}
