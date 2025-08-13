//
//  SessionsRequest.swift
//  yappu-world-ios
//
//  Created by 김도형 on 8/1/25.
//

import Foundation

struct SessionsRequest: Encodable {
    let generation: Int?
    let start: String?
    let end: String?
}
