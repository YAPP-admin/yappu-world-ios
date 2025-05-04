//
//  SchedulesEntity.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import Foundation

struct SchedulesEntity {
    let dates: [ScheduleDateEntity]
}

struct ScheduleDateEntity {
    let date: String
    let schedules: [ScheduleEntity]
    let isToday: Bool
}

struct ScheduleEntity: Hashable, Equatable {
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
    let relativeDays: Int?
    let startDayOfWeek: String?
    let endDayOfWeek: String?
}

extension ScheduleEntity {
    func toCellData(isToday: Bool, viewType: YPScheduleCellViewType) -> YPScheduleModel {
        .init(viewType: viewType, badgeType: YPScheduleBadgeType(attendanceStatus ?? "none"), isToday: isToday, item: self)
    }
}

extension ScheduleEntity {
    static func dummy() -> Self {
        .init(
            id: UUID().uuidString,
            name: "namdsa",
            place: nil,
            date: nil,
            endDate: nil,
            time: nil,
            endTime: nil,
            scheduleType: nil,
            sessionType: nil,
            scheduleProgressPhase: nil,
            attendanceStatus: nil,
            relativeDays: nil,
            startDayOfWeek: nil,
            endDayOfWeek: nil
        )
    }
}
