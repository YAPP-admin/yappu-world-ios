//
//  NoticeUseCase.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/24/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct NoticeUseCase {
    var loadNotices: @Sendable(_ model: NoticeRequest) async throws -> NoticeResponse?
    var loadNoticeDetail: @Sendable(_ id: String) async throws -> NoticeDetailResponse?
}

extension NoticeUseCase: TestDependencyKey {
    static var testValue: NoticeUseCase = {
        @Dependency(NoticeRepository.self)
        var noticeRepository
        
        return NoticeUseCase(
            loadNotices: { model in
                try await noticeRepository.loadNoticeList(model)
            },
            loadNoticeDetail: { id in
                try await noticeRepository.loadNoticeDetail(id)
            }
        )
    }()
}
