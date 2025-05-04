//
//  TabItem.swift
//  yappu-world-ios
//
//  Created by 김도형 on 4/18/25.
//

import SwiftUI

enum TabItem: CaseIterable {
    case home
    case schedule
    case notice
    case myPage
    
    var title: String {
        switch self {
        case .home: return "홈"
        case .schedule: return "일정"
        case .notice: return "게시판"
        case .myPage: return "My"
        }
    }
    
    func image(_ isSelected: Bool) -> ImageResource {
        switch self {
        case .home:
            return isSelected ? .homeFill : .home
        case .schedule: return .calendar
        case .notice: return .listCategory
        case .myPage: return .myPage
        }
    }
}
