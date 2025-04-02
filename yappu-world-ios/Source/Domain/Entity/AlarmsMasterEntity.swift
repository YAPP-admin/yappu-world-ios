//
//  AlarmsMasterEntity.swift
//  yappu-world-ios
//
//  Created by 김도형 on 3/16/25.
//

import Foundation

struct AlarmsMasterEntity {
    let isEnabled: Bool
}

extension AlarmsMasterEntity {
    static let mock = AlarmsMasterEntity(isEnabled: true)
}
