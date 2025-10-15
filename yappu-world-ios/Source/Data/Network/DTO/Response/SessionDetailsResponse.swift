//
//  SessionDetailsResponse.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/19/25.
//

import Foundation

struct SessionDetailsResponse: Decodable {
    let id: String
    let progressPhase: String
    let title: String
    let startDate: String
    let startTime: String
    let startDayOfWeek: String
    let endDate: String
    let endTime: String
    let endDayOfWeek: String
    let place: String
    let address: String
    let latitude: Double
    let longitude: Double
    let notices: [SessionNoticeResponse]
    let relativeDays: Int?
}


struct SessionNoticeResponse: Decodable {
    let notice: NoticeDTO
    let writer: WriterDTO
}

extension SessionDetailsResponse {
    static func dummy() -> Self {
        .init(
            id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
            progressPhase: "ONGOING",
            title: "개발 세션",
            startDate: "2024-01-01",
            startTime: "00:00:00",
            startDayOfWeek: "월",
            endDate: "2024-12-31",
            endTime: "00:00:00",
            endDayOfWeek: "토",
            place: "string",
            address: "string",
            latitude: 0,
            longitude: 0,
            notices: [
                .init(
                    notice: .init(
                        id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
                        title: "string",
                        content: "string",
                        noticeType: "OPERATION",
                        createdAt: "2025-10-15"
                    ),
                    writer: .init(
                        activityUnitGeneration: 0,
                        id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
                        name: "string",
                        activityUnitPosition: .init(name: "PM", label: "PM")
                    )
                )
            ],
            relativeDays: 0
        )
    }

    func toEntity() -> SessionDetailsEntity {
        .init(
            id: id,
            progressPhase: mapProgressPhase(progressPhase),
            title: title,
            startDate: startDate,
            startTime: startTime,
            startDayOfWeek: startDayOfWeek,
            endDate: endDate,
            endTime: endTime,
            endDayOfWeek: endDayOfWeek,
            place: place,
            address: address,
            latitude: latitude,
            longitude: longitude,
            notices: notices.map { $0.toEntity() },
            relativeDays: relativeDays
        )
    }


    private func mapProgressPhase(_ value: String) -> ScheduleEntity.ProgressPhase? {
        if let phase = ScheduleEntity.ProgressPhase(rawValue: value) {
            return phase
        }

        switch value.uppercased() {
        case "DONE":
            return .done
        case "ONGOING":
            return .ongoing
        case "TODAY":
            return .today
        case "PENDING":
            return .pending
        default:
            return nil
        }
    }
}


extension SessionNoticeResponse {
    func toEntity() -> NoticeEntity {
        .init(
            id: notice.id,
            notice: notice.toEntity(),
            writer: writer.toEntity()
        )
    }
}
