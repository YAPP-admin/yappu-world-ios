//
//  NoticeRepository.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/24/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct NoticeRepository {
    var loadNoticeList: @Sendable(
        _ model: NoticeRequest
    ) async throws -> PageDTO<[NoticeResponse]>?
    
    var loadNoticeDetail: @Sendable(
        _ id: String
    ) async throws -> NoticeResponse?
}

extension NoticeRepository: TestDependencyKey {
    static var testValue: NoticeRepository = {
        return NoticeRepository(
            loadNoticeList: { _ in return nil },
            loadNoticeDetail: { _ in return nil }
        )
    }()
}
