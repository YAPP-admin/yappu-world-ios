//
//  RegisterHistoryEntity.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/14/25.
//

import Foundation

enum Position: String {
    case PM = "PM"
    case UIUX_Design = "UIUX Design"
    case Android = "Android"
    case iOS = "iOS"
    case Web = "Web"
    case Server = "Server"
}

struct RegisterHistoryEntity: Hashable, Equatable {
    let id: Int
    let generation: String
    let position: Position?
}
