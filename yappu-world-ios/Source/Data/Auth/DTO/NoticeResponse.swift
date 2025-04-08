//
//  NoticeResponse.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import Foundation

// MARK: - NoticeResponse
struct NoticeResponse: Codable {
    let data: DataClass
    let isSuccess: Bool
}

// MARK: - DataClass
struct DataClass: Codable {
    let data: [Datum]
    let hasNext: Bool
    let lastCursor: String?
    let limit: Int
}

// MARK: - Datum
struct Datum: Codable {
    let writer: WriterDTO
    let notice: NoticeDTO
}

extension Datum {
    func toEntity() -> NoticeEntity {
        .init(
            id: notice.id,
            notice: notice.toEntity(),
            writer: writer.toEntity()
        )
    }
}


// MARK: - Notice
struct NoticeDTO: Codable {
    let id, title, content, noticeType: String
    let createdAt: String
}

extension NoticeDTO {
    func toEntity() -> Notice {
        .init(
            id: id,
            createdAt: createdAt,
            title: title,
            content: content,
            noticeType: BadgeType.convert(text: noticeType) ?? .Notice
        )
    }
}

// MARK: - Writer
struct WriterDTO: Codable {
    let activityUnitGeneration: Int
    let id, name: String
    let activityUnitPosition: ActivityUnitPosition

    enum CodingKeys: String, CodingKey {
        case activityUnitGeneration
        case id
        case name
        case activityUnitPosition
    }
}

extension WriterDTO {
    func toEntity() -> Writer {
        .init(
            id: id,
            name: name,
            activityUnitGeneration: activityUnitGeneration,
            activityUnitPosition: activityUnitPosition.toEntity()
        )
    }
}

// MARK: - ActivityUnitPosition
struct ActivityUnitPosition: Codable {
    let name, label: String
}

extension ActivityUnitPosition {
    func toEntity() -> ActivityUnitPositionEntity {
        .init(name: name, label: label)
    }
}



