//
//  NotificationEntity.swift
//  yappu-world-ios
//
//  Created by 김도형 on 4/1/25.
//

import Foundation

struct NotificationEntity {
    let kind: Kind?
    let data: String
}

extension NotificationEntity {
    enum Kind: String {
        case notices
    }
}
