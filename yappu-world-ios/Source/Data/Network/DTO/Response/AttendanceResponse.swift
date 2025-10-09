//
//  AttendanceResponse.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/22/25.
//

import Foundation

struct AttendanceResponse: Decodable {
    var message: String?
    let isSuccess: Bool
    var errorCode: String?
}
