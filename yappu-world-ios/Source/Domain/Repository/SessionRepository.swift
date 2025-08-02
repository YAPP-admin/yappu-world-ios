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
    var loadSessions: @Sendable(
        _ generation: Int?,
        _ start: String?,
        _ end: String?
    ) async throws -> DefaultResponse<SessionsResponse>?
}

extension SessionRepository: TestDependencyKey {
    static var testValue: SessionRepository = {
        return SessionRepository(
            loadSessions: { _, _, _ in return nil }
        )
    }()
}
