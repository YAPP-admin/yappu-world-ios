//
//  NoticeResponse.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import Foundation

struct NoticeResponse: Decodable {
    let id: String
    let boardType: BadgeType
    let content: String
    let displayTarget: DisplayTargetType
    let title: String
    let writer: String
    let totalMembers: Int?
    let readCount: Int?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case boardType
        case content
        case displayTarget
        case title
        case writer
        case totalMember
        case readCount
        case createdAt
    }
    
    init(
        id: String,
        boardType: BadgeType,
        content: String,
        displayTarget: DisplayTargetType,
        title: String,
        writer: String,
        totalMembers: Int? = nil,
        readCount: Int? = nil,
        createdAt: String
    ) {
        self.id = id
        self.boardType = boardType
        self.content = content
        self.displayTarget = displayTarget
        self.title = title
        self.writer = writer
        self.totalMembers = totalMembers
        self.readCount = readCount
        self.createdAt = createdAt
    }
    
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
        title = try container.decode(String.self, forKey: .title)
        writer = try container.decode(String.self, forKey: .writer)
        totalMembers = try container.decode(Int?.self, forKey: .totalMember)
        readCount = try container.decode(Int?.self, forKey: .readCount)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        
        let boardType = try container.decode(String.self, forKey: .boardType)
        
        if let badge = BadgeType.convert(text: boardType) {
            self.boardType = badge
        } else {
            // 매칭되는 케이스가 없을 경우의 처리
            throw DecodingError.dataCorruptedError(
                forKey: .boardType,
                in: container,
                debugDescription: "Invalid badge type: \(boardType)"
            )
        }
        
        let displayTarget = try container.decode(String.self, forKey: .displayTarget)
        
        if let display = DisplayTargetType.convert(text: displayTarget) {
            self.displayTarget = display
        } else {
            // 매칭되는 케이스가 없을 경우의 처리
            throw DecodingError.dataCorruptedError(
                forKey: .boardType,
                in: container,
                debugDescription: "Invalid badge type: \(displayTarget)"
            )
        }
    }
}

extension NoticeResponse {
    func toEntity() -> NoticeEntity {
        .init(
            id: id,
            boardType: boardType,
            content: content,
            displayTarget: displayTarget,
            title: title,
            writer: writer,
            totalMembers: totalMembers,
            readCount: readCount,
            createdAt: createdAt
        )
    }
}
