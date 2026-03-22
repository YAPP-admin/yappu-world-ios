//
//  OperationForceUpdateRequest.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/4/25.
//

import Foundation

struct OperationForceUpdateRequest: Encodable {
    var version: String
    var platform = "IOS"
    
    init(version: String, platform: String = "IOS") {
        self.version = version
        self.platform = platform
    }
}
