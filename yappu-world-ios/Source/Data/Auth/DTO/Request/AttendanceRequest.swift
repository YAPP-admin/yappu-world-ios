//
//  AttendanceRequest.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/22/25.
//

import Foundation

struct AttendanceRequest: Encodable {
    let sessionId: String
    let attendanceCode: String
}
