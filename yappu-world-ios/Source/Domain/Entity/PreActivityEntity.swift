//
//  PreActivityEntity.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import Foundation

struct PreActivityEntity: Hashable, Sendable {
    let generation: Int             // 기수
    let position: String            // 직군
    let activityStartDate: String   // 활동 시작일
    let activityEndDate: String     // 활동 종료일
}
