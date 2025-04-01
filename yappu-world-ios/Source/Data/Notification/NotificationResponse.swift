//
//  NotificationResponse.swift
//  yappu-world-ios
//
//  Created by 김도형 on 4/1/25.
//

import Foundation

struct NotificationResponse: Decodable {
    let deeplink: String
}

extension NotificationResponse {
    func toEntity() -> NotificationEntity {
        let url = URL(string: self.deeplink)
        // URL의 pathComponents는 ["/", "notices", "%7Bid%7D"] 형태로 반환됩니다.
        var components = url?.pathComponents
        
        guard
            let data = components?.popLast(),
            let kind = components?.popLast()
        else {
            return NotificationEntity(kind: nil, data: "")
        }
        return NotificationEntity(
            kind: NotificationEntity.Kind(rawValue: kind),
            data: data
        )
    }
}
