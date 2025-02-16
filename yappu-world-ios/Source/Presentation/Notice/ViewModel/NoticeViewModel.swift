//
//  NoticeViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import Foundation

@Observable
class NoticeViewModel {
    var notices: [NoticeEntity] = [
        .dummy(),
        .dummy(),
        .dummy(),
        .dummy(),
        .dummy(),
        .dummy(),
        .dummy(),
        .dummy(),
        .dummy(),
        .dummy(),
        .dummy(),
        .dummy(),
        .dummy(),
        .dummy(),
        .dummy(),
        .dummy()
    ]
    
    var selectedNoticeList: NoticeType = .전체
}

