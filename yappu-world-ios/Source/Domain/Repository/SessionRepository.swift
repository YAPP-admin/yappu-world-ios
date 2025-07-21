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
    var loadSessionsByHome: @Sendable() async throws -> DefaultResponse<SessionsResponse>?
    var loadSessionsBySession: @Sendable() async throws -> DefaultResponse<SessionsResponse>?
}

extension SessionRepository: TestDependencyKey {
    static var testValue: SessionRepository = {
        return SessionRepository(
            loadSessionsByHome: { return nil },
            loadSessionsBySession: { return nil }
        )
    }()
}
