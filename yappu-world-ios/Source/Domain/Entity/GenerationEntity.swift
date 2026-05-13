//
//  GenerationEntity.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation

struct GenerationEntity: Identifiable, Hashable, Sendable {
    var id: Int { number }
    let number: Int

    var displayName: String { "\(number)기" }
}

extension GenerationEntity {
    static func dummyList(latest: Int = 25, count: Int = 11) -> [GenerationEntity] {
        let start = max(1, latest - count + 1)
        return stride(from: latest, through: start, by: -1).map(GenerationEntity.init(number:))
    }
}
