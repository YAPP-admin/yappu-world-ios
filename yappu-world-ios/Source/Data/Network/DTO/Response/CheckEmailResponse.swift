//
//  EmailCheckResponse.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/2/25.
//

import Foundation

struct CheckEmailResponse: Decodable {
    var message: String?
    let isSuccess: Bool
    var errorCode: String?
}
