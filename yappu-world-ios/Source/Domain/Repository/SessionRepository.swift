//
//  SessionRepository.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct SessionRepository {
    var loadSessionsByHome: @Sendable(
        _ generation: Int?,
        _ start: String?,
        _ end: String?
    ) async throws -> DefaultResponse<SessionsResponse>?
    var loadSessionsBySession: @Sendable() async throws -> DefaultResponse<SessionsResponse>?
    var loadSessionDetail: @Sendable(
        _ sessionId: String
    ) async throws -> DefaultResponse<SessionDetailEntity>?
}

extension SessionRepository: TestDependencyKey {
    static var testValue: SessionRepository = {
        return SessionRepository(
            loadSessionsByHome: { _, _, _ in return nil },
            loadSessionsBySession: { return nil },
            loadSessionDetail: { _ in return nil }
        )
    }()
}
