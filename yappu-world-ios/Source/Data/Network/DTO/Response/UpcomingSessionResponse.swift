//
//  UpcomingSessionResponse.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/22/25.
//

import Foundation
import Dependencies

struct UpcomingSessionResponse: Codable {
    var data: UpcomingSession?
    var isSuccess: Bool
}

struct UpcomingSession: Codable {
    let sessionId: String       // 세션 식별자
    let name: String            // 세션 이름
    let startDate: String       // 시작 일자
    let startDayOfWeek: String  // 시작 요일
    let endDate: String         // 종료 일자
    let endDayOfWeek: String    // 종료 요일
    let startTime: String?      // 시작 시간
    let endTime: String?        // 종료 시간
    let place: String?          // 장소
    /// 세션 시작일 기준 상대 날짜. D-N 혹은 D+N 으로 표시되는 값.
    /// ex) -2(D-2): 세션 시작일 기준 2일 전
    /// ex) -1(D-1): 세션 시작일 기준 1일 전
    /// ex) 0(D-0, D+0): 세션 당일
    /// ex) +3(D+3): 세션 시작일 기준 3일 후
    let relativeDays: Int
    /// 출석이 가능한지 여부
    /// true: 미출석 상태 & 출석 가능한 시간 (세션 시작 20분 전 ~ 세션 종료 시간)
    /// false: 활동유저가 아니거나, 출석 가능한 시간이 아니거나, 이미 출석한 경우
    let canCheckIn: Bool
    /// 현재 출석 상태: "출석", "지각", "결석", "조퇴", "공결"
    /// null: 아직 출석하지 않은 경우
    let status: String?
    /// 진행 단계
    /// - "PENDING": 예정된 세션 (relativeDays < 0)
    /// - "TODAY": 세션 당일 (relativeDays = 0, 출석 가능 시간 전)
    /// - "ONGOING": 진행중인 세션 (출석 가능 시간 또는 세션 진행 중)
    /// - "DONE": 종료된 세션
    let progressPhase: String
    let notices: [Notice]      // 공지사항 목록

    struct Notice: Codable, Identifiable {
        let id: String
        let title: String
    }
}

extension UpcomingSession {
    /// 예정된 세션 (D-1)
    static func dummy() -> Self {
        return .init(
            sessionId: "552390a8-ff12-11ef-ad31-0242ac120002",
            name: "OT",
            startDate: "2025-05-08",
            startDayOfWeek: "목",
            endDate: "2025-05-08",
            endDayOfWeek: "목",
            startTime: "13:30:00",
            endTime: "17:00:00",
            place: "아몰랑",
            relativeDays: -1,
            canCheckIn: false,
            status: nil,
            progressPhase: "PENDING",
            notices: [
                UpcomingSession.Notice(id: "5523a1f4-ff12-11ef-ad31-0242ac120002", title: "[공지] OT 안내사항")
            ]
        )
    }

    /// 당일 세션 - 출석 가능한 시간
    static func todayCanCheckIn() -> Self {
        let today = Date().toString(.sessionDate)
        return .init(
            sessionId: "today-session-1",
            name: "오늘의 iOS 개발 세션",
            startDate: today,
            startDayOfWeek: "토",
            endDate: today,
            endDayOfWeek: "토",
            startTime: "18:00:00",
            endTime: "20:00:00",
            place: "잠실 캠퍼스",
            relativeDays: 0,
            canCheckIn: true,
            status: nil,
            progressPhase: "TODAY",
            notices: [
                UpcomingSession.Notice(id: "today-notice-1", title: "[공지] 오늘 세션 준비사항"),
                UpcomingSession.Notice(id: "today-notice-2", title: "[안내] 주차장 이용 안내")
            ]
        )
    }

    /// 출석 완료 상태
    static func attended() -> Self {
        let today = Date().toString(.sessionDate)
        return .init(
            sessionId: "attended-session-1",
            name: "오늘의 iOS 개발 세션",
            startDate: today,
            startDayOfWeek: "토",
            endDate: today,
            endDayOfWeek: "토",
            startTime: "18:00:00",
            endTime: "20:00:00",
            place: "잠실 캠퍼스",
            relativeDays: 0,
            canCheckIn: false,
            status: "출석",
            progressPhase: "ONGOING",
            notices: [
                UpcomingSession.Notice(id: "attended-notice-1", title: "[공지] 오늘 세션 준비사항")
            ]
        )
    }
}
