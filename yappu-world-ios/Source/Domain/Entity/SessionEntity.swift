//
//  SessionEntity.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/1/25.
//

import Foundation

struct SessionEntity: Identifiable {
    let id: String
    let name: String
    let place: String
    let date: String
    let startDayOfWeek: String
    let endDate: String
    let endDayOfWeek: String
    let relativeDays: Int
    let time: String
    let endTime: String
    let type: SessionType?
    let progressPhase: ProgressPhase?
    let attendanceStatus: String?
}

extension SessionEntity {
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

extension SessionEntity {
    static let mockList: [SessionEntity] = [
        SessionEntity(
            id: "c07aa77e-1b30-11f0-add0-0242ac140002",
            name: "가짜 세션1",
            place: "아몰랑",
            date: "2025-04-18",
            startDayOfWeek: "금",
            endDate: "2025-04-18",
            endDayOfWeek: "금",
            relativeDays: 11,
            time: "13:30:00",
            endTime: "17:00:00",
            type: .offline,
            progressPhase: .done,
            attendanceStatus: "결석"
        ),
        SessionEntity(
            id: "c07afa8b-1b30-11f0-add0-0242ac140002",
            name: "가짜 세션2",
            place: "아몰랑",
            date: "2025-05-08",
            startDayOfWeek: "목",
            endDate: "2025-05-08",
            endDayOfWeek: "목",
            relativeDays: -9,
            time: "13:30:00",
            endTime: "17:00:00",
            type: .offline,
            progressPhase: .upcoming,
            attendanceStatus: nil
        ),
        SessionEntity(
            id: "c07afa8b-1b30-11f0-add0-0242ac140003",
            name: "가짜 세션3",
            place: "아몰랑",
            date: "2025-05-11",
            startDayOfWeek: "일",
            endDate: "2025-05-11",
            endDayOfWeek: "일",
            relativeDays: -12,
            time: "13:30:00",
            endTime: "17:00:00",
            type: .offline,
            progressPhase: .pending,
            attendanceStatus: nil
        )
    ]
}
