//
//  PageDTO.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/9/25.
//

import Foundation

struct DefaultBodyDTO<Data: Decodable>: Decodable {
    let data: Data
    let isSuccess: Bool
}

struct PageDTO<Data: Decodable>: Decodable {
    let data: [Data]
    let lastCursor: String
    let limit: Int
    let hasNext: Bool
}
