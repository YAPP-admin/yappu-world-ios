//
//  SessionsResponse.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation

struct SessionsResponse: Decodable {
    let sessions: [SessionResponse]
    let upcomingSessionId: String?
}

struct SessionResponse: Decodable {
    let id: String
    let name: String
    let place: String?
    let date: String
    let startDayOfWeek: String
    let endDate: String?
    let endDayOfWeek: String?
    let relativeDays: Int
    let time: String?
    let endTime: String?
    let type: String
    let progressPhase: String?
    let attendanceStatus: String?
}

extension SessionResponse {
    func toEntity() -> ScheduleEntity {
        .init(
            id: id,
            name: name,
            place: place,
            date: date,
            endDate: endDate,
            time: time,
            endTime: endTime,
            scheduleType: "SESSION",
            sessionType: type,
            scheduleProgressPhase: progressPhase,
            attendanceStatus: attendanceStatus,
            relativeDays: relativeDays,
            startDayOfWeek: startDayOfWeek,
            endDayOfWeek: endDayOfWeek
        )
    }
}
