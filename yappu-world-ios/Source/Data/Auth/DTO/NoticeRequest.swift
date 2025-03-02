//
//  NoticeRequest.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/23/25.
//

import Foundation

struct NoticeRequest: Encodable {
    var page: Int
    let size: Int
    var displayTarget: String
}

extension NoticeRequest {
    static let mock = NoticeRequest(page: 1, size: 30, displayTarget: "")
}
