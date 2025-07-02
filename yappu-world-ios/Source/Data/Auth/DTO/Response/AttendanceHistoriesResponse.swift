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
    let sessionId: String
    let name: String
    let checkedInAt: String?
    let attendanceStatus: String
}

extension AttendanceHistoryResponse {
    func toEntity(time: String? = nil, endTime: String? = nil) -> ScheduleEntity {
        .init(
            id: sessionId,
            name: name,
            place: nil,
            date: checkedInAt,
            endDate: nil,
            time: time,
            endTime: endTime,
            scheduleType: nil,
            sessionType: nil,
            scheduleProgressPhase: nil,
            attendanceStatus: attendanceStatus,
            relativeDays: nil,
            startDayOfWeek: nil,
            endDayOfWeek: nil
        )
    }
}
