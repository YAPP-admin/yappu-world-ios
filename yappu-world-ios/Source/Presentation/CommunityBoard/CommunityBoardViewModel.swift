//
//  CommunityBoardViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/14/25.
//

import Foundation
import SwiftUI
import Dependencies
import Observation

@Observable
class CommunityBoardViewModel {
    
    var communityBoardSections: [YPSectionEntity] = [
        .init(id: .notice, title: "공지사항"),
        .init(id: .community, title: "자유게시판")
    ]
    
    var isSelected: YPSectionType = .notice
    
    init() {
        
    }
}
