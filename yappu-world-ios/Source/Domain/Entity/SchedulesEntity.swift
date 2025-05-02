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
