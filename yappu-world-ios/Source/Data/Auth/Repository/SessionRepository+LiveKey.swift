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

        return SessionRepository(loadSessionsByHome: {
            let response: DefaultResponse<SessionsResponse>? = try await networkClient
                .request(endpoint: .loadSessionsByHome)
                .response()
            
            return response
        }, loadSessionsBySession: {
            let response: DefaultResponse<SessionsResponse>? = try await networkClient
                .request(endpoint: .loadSessionsBySession)
                .response()
            
            return response
        })
    }()
}
