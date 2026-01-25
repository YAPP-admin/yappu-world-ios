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
    let name: String
    let checkedInAt: String?
    let attendanceStatus: String
}

extension AttendanceHistoryEntity {
    static func dummy() -> AttendanceHistoryEntity {
        return AttendanceHistoryEntity(
            id: "019b6d87-a161-2b71-6aa0-0cdc1bbfa621",
            sessionId: "019b6d87-a161-2b71-6aa0-0cdc1bbfa621",
            name: "세션 27",
            checkedInAt: "2026-01-18T17:38:00.906392",
            attendanceStatus: "출석"
        )
    }
}
