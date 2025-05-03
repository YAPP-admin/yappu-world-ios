//
//  AttendanceStatisticsEntity.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation

struct AttendanceStatisticEntity {
    /// 전체 세션 수
    let totalSessionCount: Int          // 전체 세션 수
    /// 남은 세션 수
    let remainingSessionCount: Int      // 남은 세션 수
    /// 세션 진행률
    let sessionProgressRate: Int        // 세션 진행률
    /// 출석 점수
    let attendancePoint: Int            // 출석 점수
    /// 출석한 세션 수
    let attendanceCount: Int            // 출석한 세션 수
    /// 지각한 세션 수
    let lateCount: Int                  // 지각한 세션 수
    /// 결석한 세션 수
    let absenceCount: Int               // 결석한 세션 수
    /// 지각 면제권 수
    let latePassCount: Int              // 지각 면제권 수
}

extension AttendanceStatisticEntity {
    static func dummy() -> AttendanceStatisticEntity {
        return AttendanceStatisticEntity(
            totalSessionCount: 21,
            remainingSessionCount: 2,
            sessionProgressRate: 79,
            attendancePoint: 90,
            attendanceCount: 3,
            lateCount: 1,
            absenceCount: 33,
            latePassCount: 82
            )
    }
}
