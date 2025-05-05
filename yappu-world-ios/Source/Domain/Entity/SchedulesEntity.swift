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
    let sessionType: SessionType?
    let scheduleProgressPhase: ProgressPhase?
    let attendanceStatus: String?
    let relativeDays: Int?
    let startDayOfWeek: String?
    let endDayOfWeek: String?
}

extension ScheduleEntity {
    enum SessionType: String {
        case offline = "OFFLINE"
        case online = "ONLINE"
        case team = "TEAM"
    }
    
    enum ProgressPhase: String {
        case done = "DONE"
        case today = "TODAY"
        case upcoming = "UPCOMING"
        case pending = "PENDING"
    }
}

extension ScheduleEntity {
    func toCellData(isToday: Bool, viewType: YPScheduleCellViewType) -> YPScheduleModel {
        .init(viewType: viewType, badgeType: YPScheduleBadgeType(attendanceStatus ?? "none"), isToday: isToday, item: self)
    }
}

extension ScheduleEntity {
    static func dummy() -> Self {
        ScheduleEntity(
            id: "c07aa77e-1b30-11f0-add0-0242ac140002",
            name: "가짜 세션1",
            place: "아몰랑",
            date: "2025-04-18",
            endDate: "2025-04-18",
            time: "13:30:00",
            endTime: "17:00:00",
            scheduleType: "SESSION",
            sessionType: .offline,
            scheduleProgressPhase: .done,
            attendanceStatus: "결석",
            relativeDays: 11,
            startDayOfWeek: "금",
            endDayOfWeek: "금"
        )
    }
    
    static let mockList: [ScheduleEntity] = [
        ScheduleEntity(
            id: "c07aa77e-1b30-11f0-add0-0242ac140002",
            name: "가짜 세션1",
            place: "아몰랑",
            date: "2025-04-18",
            endDate: "2025-04-18",
            time: "13:30:00",
            endTime: "17:00:00",
            scheduleType: "SESSION",
            sessionType: .offline,
            scheduleProgressPhase: .done,
            attendanceStatus: "결석",
            relativeDays: 11,
            startDayOfWeek: "금",
            endDayOfWeek: "금"
        ),
        ScheduleEntity(
            id: "c07afa8b-1b30-11f0-add0-0242ac140002",
            name: "가짜 세션2",
            place: "아몰랑",
            date: "2025-05-08",
            endDate: "2025-05-08",
            time: "13:30:00",
            endTime: "17:00:00",
            scheduleType: "SESSION",
            sessionType: .offline,
            scheduleProgressPhase: .upcoming,
            attendanceStatus: nil,
            relativeDays: -9,
            startDayOfWeek: "목",
            endDayOfWeek: "목"
        ),
        ScheduleEntity(
            id: "c07afa8b-1b30-11f0-add0-0242ac140003",
            name: "가짜 세션3",
            place: "아몰랑",
            date: "2025-05-11",
            endDate: "2025-05-11",
            time: "13:30:00",
            endTime: "17:00:00",
            scheduleType: "SESSION",
            sessionType: .offline,
            scheduleProgressPhase: .pending,
            attendanceStatus: nil,
            relativeDays: -12,
            startDayOfWeek: "일",
            endDayOfWeek: "일"
        )
    ]
}
