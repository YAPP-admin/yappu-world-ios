//
//  AlarmsEntity.swift
//  yappu-world-ios
//
//  Created by 김도형 on 3/16/25.
//

import Foundation

struct AlarmsEntity {
    let isMasterEnabled: Bool
}

extension AlarmsEntity {
    static let mock = AlarmsEntity(isMasterEnabled: true)
}
