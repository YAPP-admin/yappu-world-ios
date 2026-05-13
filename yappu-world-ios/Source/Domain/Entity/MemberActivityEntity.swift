//
//  MemberActivityEntity.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation

struct MemberActivityEntity: Identifiable, Hashable, Sendable {
    let id: UUID
    let generation: Int
    let position: Position?
    let isOperation: Bool
    let periodStart: String
    let periodEnd: String
    let service: ServiceSnippet?

    init(
        id: UUID = UUID(),
        generation: Int,
        position: Position?,
        isOperation: Bool,
        periodStart: String,
        periodEnd: String,
        service: ServiceSnippet?
    ) {
        self.id = id
        self.generation = generation
        self.position = position
        self.isOperation = isOperation
        self.periodStart = periodStart
        self.periodEnd = periodEnd
        self.service = service
    }
}
