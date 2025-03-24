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
    let activityUnitGeneration: Int
    let activityUnitPosition: ActivityUnitPositionEntity
}

struct ActivityUnitPositionEntity: Hashable {
    let id: UUID = UUID()
    let name: String
    let label: String
}

struct NoticeEntity: Hashable {
    let id: String
    let notice: Notice
    let writer: Writer
}

extension NoticeEntity {
    static func dummy() -> Self {
        .init(id: "", notice: .init(id: "", createdAt: "", title: "", content: "", noticeType: .Notice), writer: .init(id: "", activityUnitGeneration: 1, activityUnitPosition: .init(name: "", label: "")))
    }
}
