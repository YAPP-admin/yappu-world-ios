//
//  RegisterHistoryEntity.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/14/25.
//

import Foundation

enum Position: String {
    case PM = "PM"
    case UIUX_Design = "UXUI Design"
    case Android = "Android"
    case iOS = "iOS"
    case Web = "Web"
    case Server = "Server"
}

struct RegisterHistoryEntity: Hashable, Equatable {
    var id: Int
    let old: Bool
    var generation: String
    var position: Position?
    var state: InputState
}
