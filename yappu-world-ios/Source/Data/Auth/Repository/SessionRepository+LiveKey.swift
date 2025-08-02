//
//  SessionRepository+LiveKey.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation
import Dependencies

extension SessionRepository: DependencyKey {
    static var liveValue: SessionRepository = {
        let networkClient = NetworkClient<SessionEndPoint>.build()
        
        return SessionRepository(
            loadSessions: { generation, start, end in
                let request = SessionsRequest(
                    generation: generation,
                    start: start,
                    end: end
                )
                let response: DefaultResponse<SessionsResponse>? = try await networkClient
                    .request(endpoint: .loadSessions(request))
                    .response()
                
                return response
            }
        )
    }()
}
