//
//  NoticeDetailViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@Observable
class NoticeDetailViewModel {
    var id: String
    
    var notice: NoticeEntity = .dummy()
    
    init(id: String) {
        self.id = id
    }
}

