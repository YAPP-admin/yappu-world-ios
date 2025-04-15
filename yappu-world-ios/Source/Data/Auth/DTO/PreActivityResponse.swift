//
//  PreActivityResponse.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import Foundation

struct PreActivityResponse: Codable {
    var data: ActivityUnit
    var isSuccess: Bool
    
    struct ActivityUnit: Codable {
        var activityUnits: [PreActivityEntity]
    }
}
