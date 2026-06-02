//
//  TeamServiceUseCase.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct TeamServiceUseCase {
    /// 역대 서비스 목록 (커서 페이지네이션 + 서버사이드 generation/platform 필터)
    var loadServices: @Sendable (
        _ lastCursorId: String?,
        _ limit: Int,
        _ generation: Int?,
        _ platform: TeamServicePlatform?
    ) async throws -> TeamServicePage = { _, _, _, _ in .empty }
    var loadServiceDetail: @Sendable (_ id: String) async throws -> TeamServiceEntity? = { _ in nil }
    var loadMemberProfile: @Sendable (_ userId: String) async throws -> MemberProfileEntity? = { _ in nil }
}

extension TeamServiceUseCase: TestDependencyKey {
    static let testValue: TeamServiceUseCase = {
        let services = TeamServiceEntity.dummyList()
        return TeamServiceUseCase(
            loadServices: { _, _, generation, platform in
                try await Task.sleep(for: .milliseconds(300))
                let filtered = services
                    .filter { service in generation.map { service.generation == $0 } ?? true }
                    .filter { service in platform.map { service.platforms.contains($0) } ?? true }
                return TeamServicePage(services: filtered, lastCursor: nil, hasNext: false)
            },
            loadServiceDetail: { id in
                try await Task.sleep(for: .milliseconds(250))
                return services.first { $0.id == id } ?? services.first
            },
            loadMemberProfile: { _ in
                try await Task.sleep(for: .milliseconds(250))
                return MemberProfileEntity.dummy()
            }
        )
    }()
}
