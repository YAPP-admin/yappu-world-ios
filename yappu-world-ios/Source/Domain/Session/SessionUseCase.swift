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
    var loadSessions: @Sendable() async throws -> DefaultResponse<SessionsResponse>?
}

extension SessionUseCase: TestDependencyKey {
    static var testValue: SessionUseCase = {
        @Dependency(SessionRepository.self)
        var sessionRepository
    
        return SessionUseCase(
            loadSessions: sessionRepository.loadSessions
        )
    }()
}
