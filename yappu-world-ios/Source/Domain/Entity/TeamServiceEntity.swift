//
//  TeamServiceEntity.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation

struct TeamServiceEntity: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let teamName: String
    let generation: Int
    let platforms: [TeamServicePlatform]
    let tagline: String
    let description: String
    let thumbnailURL: URL?
    let heroImageURL: URL?
    let links: [TeamServiceLink]
    let teamMembers: [TeamServiceTeamMember]
}

extension TeamServiceEntity {
    static func dummy(
        id: String = UUID().uuidString,
        name: String = "서비스 명",
        teamName: String = "팀이름",
        generation: Int = 25,
        platforms: [TeamServicePlatform] = [.app]
    ) -> TeamServiceEntity {
        TeamServiceEntity(
            id: id,
            name: name,
            teamName: teamName,
            generation: generation,
            platforms: platforms,
            tagline: "무슨무슨을 위한 무슨무슨 서비스 두줄까지 들어갈것 같아요",
            description: """
            한반도의 경제 협력이 새로운 국면을 맞이하며 남북 간 첫 연합 기업이 설립되었습니다. \
            이 기업은 에너지, 통신, 제조 등 다양한 분야에서 남북 간 협력 모델을 제시하며 \
            경제적 도약을 목표로 하고 있습니다. 특히, 이번 연합 기업은 지속 가능한 발전을 \
            위한 친환경 기술과 공동 연구 개발을 핵심 과제로 삼고 있으며, 이를 통해 글로벌 \
            시장에서도 경쟁력을 확보하고자 합니다.
            """,
            thumbnailURL: nil,
            heroImageURL: nil,
            links: TeamServiceEntity.dummyLinks(for: platforms),
            teamMembers: TeamServiceEntity.dummyTeamMembers()
        )
    }

    static func dummyList() -> [TeamServiceEntity] {
        [
            .dummy(id: "svc-25-1", name: "Yappu World", generation: 25, platforms: [.app]),
            .dummy(id: "svc-25-2", name: "코드살롱", generation: 25, platforms: [.app]),
            .dummy(id: "svc-25-3", name: "북클럽", generation: 25, platforms: [.web]),
            .dummy(id: "svc-25-4", name: "유니버설 트래커", generation: 25, platforms: [.app, .web]),
            .dummy(id: "svc-24-1", name: "헬로얍", generation: 24, platforms: [.app]),
            .dummy(id: "svc-24-2", name: "스터디룸", generation: 24, platforms: [.app]),
            .dummy(id: "svc-23-1", name: "캠퍼스 라이프", generation: 23, platforms: [.web]),
            .dummy(id: "svc-23-2", name: "런닝메이트", generation: 23, platforms: [.web]),
        ]
    }

    private static func dummyLinks(for platforms: [TeamServicePlatform]) -> [TeamServiceLink] {
        var links: [TeamServiceLink] = []
        if platforms.contains(.app) {
            if let url = URL(string: "https://apps.apple.com/") {
                links.append(.init(kind: .appStore, url: url))
            }
            if let url = URL(string: "https://play.google.com/") {
                links.append(.init(kind: .playStore, url: url))
            }
        }
        if platforms.contains(.web) {
            if let url = URL(string: "https://yapp.co.kr/") {
                links.append(.init(kind: .web, url: url))
            }
        }
        return links
    }

    private static func dummyTeamMembers() -> [TeamServiceTeamMember] {
        [
            .init(id: "mem-1", name: "김얍얍", position: .PM),
            .init(id: "mem-2", name: "김뿌야", position: .UIUX_Design),
            .init(id: "mem-3", name: "김도형", position: .iOS),
            .init(id: "mem-4", name: "이안드", position: .Android),
            .init(id: "mem-5", name: "박서버", position: .Server),
        ]
    }
}
