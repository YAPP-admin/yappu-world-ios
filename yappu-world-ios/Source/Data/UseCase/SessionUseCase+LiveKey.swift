//
//  SessionUseCase+LiveKey.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation
import Dependencies

extension SessionUseCase: DependencyKey {
    static var liveValue: SessionUseCase = {
        @Dependency(SessionRepository.self)
        var sessionRepository
        
        return SessionUseCase(
            loadSessions: sessionRepository.loadSessions
        )
    }()
}
