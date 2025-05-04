//
//  SchedulesResponse.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import Foundation

struct SchedulesResponse: Decodable {
    let dates: [ScheduleDateResponse]
}

struct ScheduleDateResponse: Decodable {
    let date: String
    let schedules: [ScheduleResponse]
    let isToday: Bool
}

struct ScheduleResponse: Decodable {
    let id: String
    let name: String
    let place: String?
    let date: String?
    let endDate: String?
    let time: String?
    let endTime: String?
    let scheduleType: String?
    let sessionType: String?
    let scheduleProgressPhase: String?
    let attendanceStatus: String?
}

extension SchedulesResponse {
    func toEntity() -> SchedulesEntity {
        .init(dates: dates.map { $0.toEntity() })
    }
}

extension ScheduleDateResponse {
    func toEntity() -> ScheduleDateEntity {
        .init(date: date, schedules: schedules.map { $0.toEntity() }, isToday: isToday)
    }
}

extension ScheduleResponse {
    func toEntity() -> ScheduleEntity {
        .init(
            id: id,
            name: name,
            place: place,
            date: date,
            endDate: endDate,
            time: time,
            endTime: endTime,
            scheduleType: scheduleType,
            sessionType: sessionType,
            scheduleProgressPhase: scheduleProgressPhase,
            attendanceStatus: attendanceStatus,
            relativeDays: nil,
            startDayOfWeek: nil,
            endDayOfWeek: nil
        )
    }
}
