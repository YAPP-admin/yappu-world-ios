//
//  PastServiceTeamMember.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation

struct PastServiceTeamMember: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let position: Position
}
