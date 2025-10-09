//
//  DefaultResponse.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import Foundation

struct DefaultResponse<T: Decodable> : Decodable {
    let data: T
    let isSuccess: Bool
}
