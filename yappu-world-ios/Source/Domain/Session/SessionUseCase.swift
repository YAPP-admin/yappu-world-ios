//
//  SessionUseCase.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct SessionUseCase {
    var loadSessionsByHome: @Sendable(
        _ generation: Int?,
        _ start: String?,
        _ end: String?
    ) async throws -> DefaultResponse<SessionsResponse>?
    var loadSessionsBySession: @Sendable() async throws -> DefaultResponse<SessionsResponse>?
    var loadSessionDetail: @Sendable(
        _ sessionId: String?
    ) async throws -> DefaultResponse<SessionDetailResponse>?
}

extension SessionUseCase: TestDependencyKey {
    static var testValue: SessionUseCase = {
        @Dependency(SessionRepository.self)
        var sessionRepository
        
        return SessionUseCase(
            loadSessionsByHome: sessionRepository.loadSessionsByHome,
            loadSessionsBySession: sessionRepository.loadSessionsBySession,
            loadSessionDetail: sessionRepository.loadSessionDetail
        )
    }()
}
