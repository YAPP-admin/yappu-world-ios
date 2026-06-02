//
//  TeamServiceRequest.swift
//  yappu-world-ios
//
//  Created by 김도형 on 6/2/26.
//

import Foundation

/// 역대 서비스 목록 조회 쿼리. nil 필드는 makeNotNilParameters에서 제외됨.
struct TeamServiceRequest: Encodable {
    let lastCursorId: String?
    let limit: Int
    let generation: Int?
    let platform: String?
}
