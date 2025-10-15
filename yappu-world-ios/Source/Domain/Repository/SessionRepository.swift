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
    var detail: @Sendable (
        _ sessionId: String
    ) async throws -> SessionDetailsEntity
}

extension SessionRepository: TestDependencyKey {
    static var testValue: SessionRepository = {
        return SessionRepository(
            loadSessionsByHome: { _, _, _ in return nil },
            loadSessionsBySession: { return nil },
            detail: { _ in return SessionDetailsResponse.dummy().toEntity() }
        )
    }()
}
