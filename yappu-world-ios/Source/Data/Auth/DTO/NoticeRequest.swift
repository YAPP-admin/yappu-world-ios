//
//  NoticeRequest.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/23/25.
//

import Foundation

struct NoticeRequest: Encodable {
    let lastCursorId: String?
    let limit: Int
    var noticeType: String
}

extension NoticeRequest {
    static let mock = NoticeRequest(lastCursorId: nil, limit: 30, noticeType: "ALL")
}
