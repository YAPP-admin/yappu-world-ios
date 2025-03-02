//
//  HomeRepository+LiveKey.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import Foundation
import Dependencies

extension HomeRepository: DependencyKey {
    static var liveValue: HomeRepository = {
        
        let tokenNetworkClient = NetworkClient<HomeEndPoint>.build()
        
        return HomeRepository(
            loadProfile: {
                let response: ProfileResponse = try await tokenNetworkClient.request(endpoint: .loadProfile)
                    .response()
                
                return response
        })
    }()
}
