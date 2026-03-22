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
            sessionType: .init(rawValue: type),
            scheduleProgressPhase: .init(rawValue: progressPhase ?? ""),
            attendanceStatus: attendanceStatus,
            relativeDays: relativeDays,
            startDayOfWeek: startDayOfWeek,
            endDayOfWeek: endDayOfWeek
        )
    }

    func toUpcomingSession(notices: [UpcomingSession.Notice]) -> UpcomingSession {
        UpcomingSession(
            sessionId: id,
            name: name,
            startDate: date,
            startDayOfWeek: startDayOfWeek,
            endDate: endDate ?? date,
            endDayOfWeek: endDayOfWeek ?? startDayOfWeek,
            startTime: time,
            endTime: endTime,
            place: place,
            relativeDays: relativeDays,
            canCheckIn: calculateCanCheckIn(),
            status: attendanceStatus,
            progressPhase: mapProgressPhaseToEnglish(progressPhase),
            notices: notices
        )
    }

    /// 한글 progressPhase를 영어로 매핑
    /// - "종료" → "DONE"
    /// - "당일" → "TODAY"
    /// - "진행 중" → "ONGOING"
    /// - "예정" → "PENDING"
    private func mapProgressPhaseToEnglish(_ phase: String?) -> String {
        switch phase {
        case "종료": return "DONE"
        case "당일": return "TODAY"
        case "진행 중": return "ONGOING"
        case "예정": return "PENDING"
        default: return "PENDING"
        }
    }

    private func calculateCanCheckIn() -> Bool {
        // 이미 출석 처리된 경우 false
        guard attendanceStatus == nil || attendanceStatus == "미출석" else { return false }

        // progressPhase가 "당일" 또는 "진행 중"인 경우만 출석 가능
        guard progressPhase == "당일" || progressPhase == "진행 중" else { return false }

        // 시간 체크: 출석 가능한 시간인지 확인
        guard let startTime = time, let endTime = endTime else { return false }

        let startDateTime = "\(date) \(startTime)".toDate(.sessionDateTime)
        let endDateTime = "\(endDate ?? date) \(endTime)".toDate(.sessionDateTime)

        guard let start = startDateTime, let end = endDateTime else { return false }

        let now = Date()
        let checkInStart = start.addingTimeInterval(-20 * 60) // 세션 시작 20분 전

        return now >= checkInStart && now <= end
    }
}
