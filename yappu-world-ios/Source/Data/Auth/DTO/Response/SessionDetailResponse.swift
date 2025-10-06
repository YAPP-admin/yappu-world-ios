//
//  SessionDetailResponse.swift
//  yappu-world-ios
//
//  Created by 김건형 on 9/29/25.
//

import Foundation

struct SessionDetailResponse: Decodable {
    let data: SessionDetailEntity
    let isSuccess: Bool
}
