//
//  AttendanceHistoriesResponse.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation

struct AttendanceHistoriesResponse: Decodable {
    let histories: [AttendanceHistoryResponse]
}

struct AttendanceHistoryResponse: Decodable {
    /// 세션 식별자
    let sessionId: String
    /// 세션 제목
    let title: String
    /// 세션 종류 (OFFLINE | ONLINE | TEAM)
    let sessionType: String
    /// 세션 시작 일시
    let startAt: String
    /// 세션 종료 일시
    let endAt: String
    /// 출석 시간 (미출석 시 nil)
    let checkedInAt: String?
    /// 출석 상태 (PENDING | ON_TIME | LATE | ABSENT | EARLY_CHECK_OUT | EXCUSED_ABSENCE)
    let attendanceStatus: String?
    /// 세션 진행 상태 (DONE | ONGOING | TODAY | PENDING)
    let progressPhase: String
}

extension AttendanceHistoriesResponse {
    func toEntity() -> AttendanceHistoriesEntity {
        .init(histories: histories.map { $0.toEntity() })
    }
}

extension AttendanceHistoryResponse {
    func toEntity() -> AttendanceHistoryEntity {
        .init(
            id: sessionId,
            sessionId: sessionId,
            title: title,
            sessionType: sessionType,
            startAt: startAt,
            endAt: endAt,
            checkedInAt: checkedInAt,
            attendanceStatus: attendanceStatus,
            progressPhase: progressPhase
        )
    }
}
