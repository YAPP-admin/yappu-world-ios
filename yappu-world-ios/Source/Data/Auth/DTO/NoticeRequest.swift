//
//  NoticeRequest.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/23/25.
//

import Foundation

struct NoticeRequest: Encodable {
    let limit: Int
    var noticeType: String
}

extension NoticeRequest {
    static let mock = NoticeRequest(limit: 30, noticeType: "ALL")
}
