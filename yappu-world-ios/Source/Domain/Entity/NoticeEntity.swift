//
//  NoticeEntity.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/23/25.
//

import Foundation

struct Notice: Hashable {
    let id: String
    let createdAt: String
    let title: String
    let content: String
    let noticeType: BadgeType
}

struct Writer: Hashable {
    var id: String
    let name: String
    let activityUnitGeneration: Int
    let activityUnitPosition: ActivityUnitPositionEntity
}

struct ActivityUnitPositionEntity: Hashable {
    let id: UUID = UUID()
    let name: String
    let label: String
}

struct NoticeEntity: Hashable, Sendable {
    let id: String
    let notice: Notice
    let writer: Writer
}

extension NoticeEntity {
    static func dummy() -> Self {
        .init(id: "\(Int.random(in: 0...5000000))",
              notice: .init(id: "\(Int.random(in: 0...5000000))",
                            createdAt: "\(Int.random(in: 0...5000000))",
                            title: "\(Int.random(in: 0...900000000))",
                            content: "TestTest",
                            noticeType: .Notice),
              writer: .init(id: "\(Int.random(in: 0...5000000))",
                            name: "\(Int.random(in: 0...5000000))",
                            activityUnitGeneration: 1,
                            activityUnitPosition: .init(name: "\(Int.random(in: 0...5000000))",
                                                        label: "\(Int.random(in: 0...5000000))"
                                                       )))
    }
}
