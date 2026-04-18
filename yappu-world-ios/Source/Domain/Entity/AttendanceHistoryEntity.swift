//
//  AttendanceHistoryEntity.swift
//  yappu-world-ios
//
//  Created by Claude on 1/18/26.
//

import Foundation

struct AttendanceHistoriesEntity {
    let histories: [AttendanceHistoryEntity]
}

struct AttendanceHistoryEntity: Identifiable, Equatable, Hashable {
    let id: String // sessionId
    let sessionId: String
    let title: String
    let sessionType: String
    let startAt: String
    let endAt: String
    let checkedInAt: String?
    let attendanceStatus: String?
    let progressPhase: String
}

extension AttendanceHistoryEntity {
    // DONE + ON_TIME → 노출 O
    static func dummy() -> AttendanceHistoryEntity {
        return AttendanceHistoryEntity(
            id: "019b6d87-a161-2b71-6aa0-0cdc1bbfa621",
            sessionId: "019b6d87-a161-2b71-6aa0-0cdc1bbfa621",
            title: "OT 세션",
            sessionType: "OFFLINE",
            startAt: "2026-01-18T17:00:00.000000",
            endAt: "2026-01-18T21:00:00.000000",
            checkedInAt: "2026-01-18T17:05:00.000000",
            attendanceStatus: "ON_TIME",
            progressPhase: "DONE"
        )
    }

    // DONE + LATE → 노출 O
    static func dummyLate() -> AttendanceHistoryEntity {
        AttendanceHistoryEntity(
            id: "019b6d87-a161-2b71-6aa0-0cdc1bbfa622",
            sessionId: "019b6d87-a161-2b71-6aa0-0cdc1bbfa622",
            title: "팀 매칭/빌딩 세션",
            sessionType: "OFFLINE",
            startAt: "2026-01-25T13:00:00.000000",
            endAt: "2026-01-25T17:00:00.000000",
            checkedInAt: "2026-01-25T13:25:00.000000",
            attendanceStatus: "LATE",
            progressPhase: "DONE"
        )
    }

    // DONE + ABSENT → 노출 O
    static func dummyAbsent() -> AttendanceHistoryEntity {
        AttendanceHistoryEntity(
            id: "019b6d87-a161-2b71-6aa0-0cdc1bbfa623",
            sessionId: "019b6d87-a161-2b71-6aa0-0cdc1bbfa623",
            title: "팀 플레잉 세션",
            sessionType: "OFFLINE",
            startAt: "2026-02-01T13:00:00.000000",
            endAt: "2026-02-01T17:00:00.000000",
            checkedInAt: nil,
            attendanceStatus: "ABSENT",
            progressPhase: "DONE"
        )
    }

    // DONE + EXCUSED_ABSENCE (공결) → 노출 O
    static func dummyExcusedAbsence() -> AttendanceHistoryEntity {
        AttendanceHistoryEntity(
            id: "019b6d87-a161-2b71-6aa0-0cdc1bbfa624",
            sessionId: "019b6d87-a161-2b71-6aa0-0cdc1bbfa624",
            title: "해커톤 세션",
            sessionType: "OFFLINE",
            startAt: "2026-02-08T10:00:00.000000",
            endAt: "2026-02-08T18:00:00.000000",
            checkedInAt: nil,
            attendanceStatus: "EXCUSED_ABSENCE",
            progressPhase: "DONE"
        )
    }

    // DONE + EARLY_CHECK_OUT (조퇴) → 노출 O
    static func dummyEarlyCheckOut() -> AttendanceHistoryEntity {
        AttendanceHistoryEntity(
            id: "019b6d87-a161-2b71-6aa0-0cdc1bbfa625",
            sessionId: "019b6d87-a161-2b71-6aa0-0cdc1bbfa625",
            title: "데모데이 세션",
            sessionType: "OFFLINE",
            startAt: "2026-02-15T13:00:00.000000",
            endAt: "2026-02-15T17:00:00.000000",
            checkedInAt: "2026-02-15T13:10:00.000000",
            attendanceStatus: "EARLY_CHECK_OUT",
            progressPhase: "DONE"
        )
    }

    // PENDING + EXCUSED_ABSENCE (어드민이 미리 공결 반영) → 노출 O
    static func dummyPendingExcused() -> AttendanceHistoryEntity {
        AttendanceHistoryEntity(
            id: "019b6d87-a161-2b71-6aa0-0cdc1bbfa626",
            sessionId: "019b6d87-a161-2b71-6aa0-0cdc1bbfa626",
            title: "스터디 세션",
            sessionType: "ONLINE",
            startAt: "2026-03-01T14:00:00.000000",
            endAt: "2026-03-01T16:00:00.000000",
            checkedInAt: nil,
            attendanceStatus: "EXCUSED_ABSENCE",
            progressPhase: "PENDING"
        )
    }

    // PENDING + nil (순수 예정 세션) → 노출 X
    static func dummyUpcoming() -> AttendanceHistoryEntity {
        AttendanceHistoryEntity(
            id: "019b6d87-a161-2b71-6aa0-0cdc1bbfa627",
            sessionId: "019b6d87-a161-2b71-6aa0-0cdc1bbfa627",
            title: "커피챗 세션",
            sessionType: "OFFLINE",
            startAt: "2026-03-08T13:00:00.000000",
            endAt: "2026-03-08T17:00:00.000000",
            checkedInAt: nil,
            attendanceStatus: nil,
            progressPhase: "PENDING"
        )
    }

    // PENDING + PENDING status (예정 상태값) → 노출 X
    static func dummyPendingStatus() -> AttendanceHistoryEntity {
        AttendanceHistoryEntity(
            id: "019b6d87-a161-2b71-6aa0-0cdc1bbfa628",
            sessionId: "019b6d87-a161-2b71-6aa0-0cdc1bbfa628",
            title: "최종 발표 세션",
            sessionType: "OFFLINE",
            startAt: "2026-03-15T13:00:00.000000",
            endAt: "2026-03-15T17:00:00.000000",
            checkedInAt: nil,
            attendanceStatus: "PENDING",
            progressPhase: "PENDING"
        )
    }

    static func dummies() -> [AttendanceHistoryEntity] {
        [
            .dummy(),
            .dummyLate(),
            .dummyAbsent(),
            .dummyExcusedAbsence(),
            .dummyEarlyCheckOut(),
            .dummyPendingExcused(),
            .dummyUpcoming(),
            .dummyPendingStatus()
        ]
    }
}
