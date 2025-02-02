//
//  ErrorResponse.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/2/25.
//

import Foundation

public struct ErrorResponse: Error, Decodable {
    let message: String
    let errorCode: String
    let isSuccess: Bool
}
