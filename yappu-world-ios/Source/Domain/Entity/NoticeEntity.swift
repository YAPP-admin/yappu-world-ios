//
//  NoticeEntity.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/23/25.
//

import Foundation

struct NoticeEntity: Hashable {
    let id: String
    let boardType: BadgeType
    let content: String
    let displayTarget: DisplayTargetType
    let title: String
    let writer: String
    let totalMembers: Int?
    let readCount: Int?
    let createdAt: String
}

extension NoticeEntity {
    static func dummy() -> Self {
        .init(
            id: "\(Int.random(in: 0...9999))",
            boardType: Int.random(in: 0...1) == 0 ? .Notice : .Session,
            content: "한반도의 경제 협력이 새로운 국면을 맞이하며 남북 간 첫 연합 기업이 설립되었습니다. 이 기업은 에너지, 통신, 제한반도의 경제 협력이 새로운 국면을 맞이하며 남북 간 첫 연합 기업이 설립되었습니다. 이 기업은 에너지, 통신, 제한반도의 경제 협력이 새로운 국면을 맞이하며 남북 간 첫 연합 기업이 설립되었습니다. 이 기업은 에너지, 통신, 제한반도의 경제 협력이 새로운 국면을 맞이하며 남북 간 첫 연합 기업이 설립되었습니다. 이 기업은 에너지, 통신, 제",
            displayTarget: Int.random(in: 0...1) == 0 ? .Player : .Certificated,
            title: "심장 건강을 책임지는 스마트 워치,심박수 감시와 예das스마트 워치,심박수 감시와 예das스마트 워치,심박수 감시와 예das스마트 워치,심박수 감시와 예das스마트 워치,심박수 감시와 예das스마트 워치,심박수 감시와 예das",
            writer: "20기 홍길동",
            totalMembers: nil,
            readCount: nil,
            createdAt: "\(Int.random(in: 2000...2025))-\(Int.random(in: 01...12))-\(Int.random(in: 01...31))"
        )
    }
}
