//
//  AttendanceHistoriesResponse.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation

struct AttendanceHistoriesResponse: Decodable {
    let histories: [AttendanceHistoryResponse]
}

struct AttendanceHistoryResponse: Decodable {
    let sessionId: String
    let name: String
    let checkedInAt: String?
    let attendanceStatus: String
}

extension AttendanceHistoriesResponse {
    func toEntity() -> AttendanceHistoriesEntity {
        .init(histories: histories.map { $0.toEntity() })
    }
}

extension AttendanceHistoryResponse {
    func toEntity() -> AttendanceHistoryEntity {
        .init(
            id: sessionId,
            sessionId: sessionId,
            name: name,
            checkedInAt: checkedInAt,
            attendanceStatus: attendanceStatus
        )
    }
}
