//
//  NoticeUseCase+LiveKey.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/26/25.
//

import Foundation
import Dependencies

extension NoticeUseCase: DependencyKey {
    static var liveValue: NoticeUseCase = {
        @Dependency(NoticeRepository.self)
        var noticeRpository
        
        return NoticeUseCase(
            loadNotices: noticeRpository.loadNoticeList(model:),
            loadNoticeDetail: noticeRpository.loadNoticeDetail(id:)
        )
    }()
}
