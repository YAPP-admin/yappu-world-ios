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
    let sessionId: String       // 세션 식별자
    let name: String            // 세션 이름
    let startDate: String       // 시작 일자
    let startDayOfWeek: String  // 시작 요일
    let endDate: String         // 종료 일자
    let endDayOfWeek: String    // 종료 요일
    let startTime: String?      // 시작 시간
    let endTime: String?        // 종료 시간
    let place: String?          // 장소
    /// 세션 시작일 기준 상대 날짜. D-N 혹은 D+N 으로 표시되는 값.
    /// ex) -2(D-2): 세션 시작일 기준 2일 전
    /// ex) 0(D-0, D+0): 세션 당일
    /// ex) +3(D+3): 세션 시작일 기준 3일 후
    let relativeDays: Int
    let canCheckIn: Bool        // 출석이 가능한지 여부
    let status: String?         // 현재 출석 상태
}

extension UpcomingSession {
    static func dummy() -> Self {
        return .init(sessionId: "552390a8-ff12-11ef-ad31-0242ac120002", name: "OT", startDate: "2025-05-08", startDayOfWeek: "목", endDate: "2025-05-08", endDayOfWeek: "목", startTime: "13:30:00", endTime: "17:00:00", place: "아몰랑", relativeDays: -1, canCheckIn: false, status: nil)
    }
}
