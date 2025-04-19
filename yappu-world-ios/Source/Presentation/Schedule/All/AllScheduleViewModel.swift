//
//  AllScheduleViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/19/25.
//

import Foundation

@Observable
class AllScheduleViewModel {
    var sections: [YPSectionEntity] = [
        .init(id: .all, title: "전체"),
        .init(id: .session, title: "세션")
    ]
    
    var isSelected: YPSectionType = .all
    
}
