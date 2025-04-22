//
//  UpcomingSessionResponse.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/22/25.
//

import Foundation
import Dependencies

struct UpcomingSessionResponse: Codable {
    var data: UpcomingSession
    var isSuccess: Bool
}

struct UpcomingSession: Codable {
    let sessionId: String   // 세션 식별자
    let date: String        // 세션 일자
    let canCheckIn: Bool    // 출석이 가능한지 여부
    let status: String?     // 현재 출석 상태
}
