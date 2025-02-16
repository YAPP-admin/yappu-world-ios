//
//  NoticeEntity.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import Foundation

struct NoticeEntity: Hashable {
    let id: Int
    let badge: BadgeType
    let title: String
    let writer: String
    let createdAt: String
    let content: String
}
 
extension NoticeEntity {
    static func dummy() -> Self {
        .init(id: Int.random(in: 0...9999),
              badge: Int.random(in: 0...1) == 0 ? .Notice : .Session,
              title: "심장 건강을 책임지는 스마트 워치,심박수 감시와 예das스마트 워치,심박수 감시와 예das스마트 워치,심박수 감시와 예das스마트 워치,심박수 감시와 예das스마트 워치,심박수 감시와 예das스마트 워치,심박수 감시와 예das",
              writer: "20기 홍길동",
              createdAt: "\(Int.random(in: 2000...2025))-\(Int.random(in: 01...12))-\(Int.random(in: 01...31))",
              content: "한반도의 경제 협력이 새로운 국면을 맞이하며 남북 간 첫 연합 기업이 설립되었습니다. 이 기업은 에너지, 통신, 제한반도의 경제 협력이 새로운 국면을 맞이하며 남북 간 첫 연합 기업이 설립되었습니다. 이 기업은 에너지, 통신, 제한반도의 경제 협력이 새로운 국면을 맞이하며 남북 간 첫 연합 기업이 설립되었습니다. 이 기업은 에너지, 통신, 제한반도의 경제 협력이 새로운 국면을 맞이하며 남북 간 첫 연합 기업이 설립되었습니다. 이 기업은 에너지, 통신, 제")
    }
    
}
