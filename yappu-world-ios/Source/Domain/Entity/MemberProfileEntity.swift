//
//  MemberProfileEntity.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation

struct MemberProfileEntity: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let role: String
    let profileImageURL: URL?
    let latestGeneration: Int
    let latestPosition: Position
    let activities: [MemberActivityEntity]
}

extension MemberProfileEntity {
    static func dummy(name: String = "김뿌야") -> MemberProfileEntity {
        // serviceId는 PastServiceEntity.dummyList()의 ID와 일치 — 스니펫 탭 시 상세가 정상 로드되도록
        let activities: [MemberActivityEntity] = [
            .init(
                generation: 25,
                position: .UIUX_Design,
                isOperation: false,
                periodStart: "23.11.01",
                periodEnd: "24.06.30",
                service: ServiceSnippet.dummy(serviceId: "svc-25-4", platforms: [.app, .web])
            ),
            .init(
                generation: 20,
                position: nil,
                isOperation: true,
                periodStart: "23.11.01",
                periodEnd: "24.06.30",
                service: nil
            ),
            .init(
                generation: 19,
                position: .UIUX_Design,
                isOperation: false,
                periodStart: "23.11.01",
                periodEnd: "24.06.30",
                service: ServiceSnippet.dummy(serviceId: "svc-24-1", platforms: [.app, .web])
            ),
            .init(
                generation: 17,
                position: .PM,
                isOperation: false,
                periodStart: "23.11.01",
                periodEnd: "24.06.30",
                service: ServiceSnippet.dummy(serviceId: "svc-23-1", platforms: [.app])
            ),
            .init(
                generation: 16,
                position: .Android,
                isOperation: false,
                periodStart: "23.11.01",
                periodEnd: "24.06.30",
                service: ServiceSnippet.dummy(serviceId: "svc-23-2", platforms: [.app])
            ),
        ]
        return MemberProfileEntity(
            id: "mem-2",
            name: name,
            role: "활동회원",
            profileImageURL: nil,
            latestGeneration: 25,
            latestPosition: .UIUX_Design,
            activities: activities
        )
    }
}
