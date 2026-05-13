//
//  ServiceSnippet.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation

struct ServiceSnippet: Hashable, Sendable {
    let name: String
    let teamName: String
    let description: String
    let platforms: [PastServicePlatform]
}

extension ServiceSnippet {
    static func dummy(
        name: String = "서비스명",
        teamName: String = "팀이름",
        platforms: [PastServicePlatform] = [.app]
    ) -> ServiceSnippet {
        ServiceSnippet(
            name: name,
            teamName: teamName,
            description: "무슨무슨을 위한 무슨무슨 서비스 두줄까지 들어갈 것 같아요",
            platforms: platforms
        )
    }
}
