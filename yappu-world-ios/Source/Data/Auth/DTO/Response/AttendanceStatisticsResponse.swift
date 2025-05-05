//
//  AttendenceStatisticsResponse.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation

struct AttendanceStatisticResponse: Decodable {
    let totalSessionCount: Int
    let remainingSessionCount: Int
    let sessionProgressRate: Int
    let attendancePoint: Int
    let attendanceCount: Int
    let lateCount: Int
    let absenceCount: Int
    let latePassCount: Int
}

extension AttendanceStatisticResponse {
    func toEntity() -> AttendanceStatisticEntity {
        .init(
            totalSessionCount: totalSessionCount,
            remainingSessionCount: remainingSessionCount,
            sessionProgressRate: sessionProgressRate,
            attendancePoint: attendancePoint,
            attendanceCount: attendanceCount,
            lateCount: lateCount,
            absenceCount: absenceCount,
            latePassCount: latePassCount
        )
    }
}

