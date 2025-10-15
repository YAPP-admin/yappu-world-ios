//
//  SchedulesEntity.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import SwiftUI

struct SchedulesEntity {
    let dates: [ScheduleDateEntity]
}

struct ScheduleDateEntity {
    let date: String
    let schedules: [ScheduleEntity]
    let isToday: Bool
}

struct ScheduleEntity: Hashable, Equatable, Identifiable {
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
        case done = "종료"
        case ongoing = "진행 중"
        case today = "당일"
        case pending = "예정"
        
        var sortOrder: Int {
            switch self {
            case .done: return 0
            case .ongoing: return 1
            case .today: return 2
            case .pending: return 3
            }
        }
        
        var color: Color {
            switch self {
            case .done, .ongoing, .pending: return .coolNeutral50
            case .today: return .yapp(.semantic(.primary(.normal)))
            }
        }
        
        var title: String {
            switch self {
            case .done: return "종료"
            case .pending: return "예정"
            case .today: return "당일"
            case .ongoing: return "진행 중"
            }
        }
    }
}

extension ScheduleEntity {
    func toCellData(isToday: Bool, viewType: YPScheduleCellViewType) -> YPScheduleModel {
        .init(viewType: viewType, badgeType: YPScheduleBadgeType((scheduleProgressPhase ?? .none) == .pending ? "예정" : attendanceStatus ?? "none"), isToday: isToday, item: self)
    }
}

extension ScheduleEntity {
    static func dummy() -> Self {
        ScheduleEntity(
            id: "c07aa77e-1b30-11f0-add0-0242ac140002",
            name: "가짜 세션1",
            place: "아몰랑",
            date: "2025-04-17T13:18:17",
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
        // 오늘 세션
        ScheduleEntity(
            id: "today-session-1",
            name: "오늘의 iOS 개발 세션",
            place: "잠실 캠퍼스",
            date: Date().toString(.sessionDate),
            endDate: Date().toString(.sessionDate),
            time: "18:00:00",
            endTime: "20:00:00",
            scheduleType: "SESSION",
            sessionType: .offline,
            scheduleProgressPhase: .today,
            attendanceStatus: nil,
            relativeDays: 0,
            startDayOfWeek: "토",
            endDayOfWeek: "토"
        ),
        // 미래 세션들
        ScheduleEntity(
            id: "future-session-1",
            name: "다음주 안드로이드 세션",
            place: "강남 오피스",
            date: Calendar.current.date(byAdding: .day, value: 7, to: Date())?.toString(.sessionDate) ?? "2025-10-19",
            endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())?.toString(.sessionDate) ?? "2025-10-19",
            time: "19:00:00",
            endTime: "21:00:00",
            scheduleType: "SESSION",
            sessionType: .online,
            scheduleProgressPhase: .pending,
            attendanceStatus: nil,
            relativeDays: 7,
            startDayOfWeek: "토",
            endDayOfWeek: "토"
        ),
        ScheduleEntity(
            id: "future-session-2",
            name: "프로젝트 발표 세션",
            place: "온라인",
            date: Calendar.current.date(byAdding: .day, value: 14, to: Date())?.toString(.sessionDate) ?? "2025-10-26",
            endDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())?.toString(.sessionDate) ?? "2025-10-26",
            time: "14:00:00",
            endTime: "17:00:00",
            scheduleType: "SESSION",
            sessionType: .team,
            scheduleProgressPhase: .pending,
            attendanceStatus: nil,
            relativeDays: 14,
            startDayOfWeek: "토",
            endDayOfWeek: "토"
        ),
        // 최근 과거 세션들
        ScheduleEntity(
            id: "past-session-1",
            name: "지난주 디자인 시스템 세션",
            place: "잠실 캠퍼스",
            date: Calendar.current.date(byAdding: .day, value: -7, to: Date())?.toString(.sessionDate) ?? "2025-10-05",
            endDate: Calendar.current.date(byAdding: .day, value: -7, to: Date())?.toString(.sessionDate) ?? "2025-10-05",
            time: "18:30:00",
            endTime: "20:30:00",
            scheduleType: "SESSION",
            sessionType: .offline,
            scheduleProgressPhase: .done,
            attendanceStatus: "출석",
            relativeDays: -7,
            startDayOfWeek: "토",
            endDayOfWeek: "토"
        ),
        ScheduleEntity(
            id: "past-session-2",
            name: "3일 전 백엔드 API 세션",
            place: "강남 오피스",
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date())?.toString(.sessionDate) ?? "2025-10-09",
            endDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())?.toString(.sessionDate) ?? "2025-10-09",
            time: "19:00:00",
            endTime: "21:00:00",
            scheduleType: "SESSION",
            sessionType: .online,
            scheduleProgressPhase: .done,
            attendanceStatus: "지각",
            relativeDays: -3,
            startDayOfWeek: "수",
            endDayOfWeek: "수"
        ),
        // 기존 세션들
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
