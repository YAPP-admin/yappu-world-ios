//
//  MyPageRepository+LiveKey.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import Foundation
import Dependencies

extension MyPageRepository: DependencyKey {
    static var liveValue: MyPageRepository = {
        
        let tokenNetworkClient = NetworkClient<MyPageEndPoint>.build()
        
        return MyPageRepository(
            loadProfile: {
                let response: ProfileResponse = try await tokenNetworkClient
                    .request(endpoint: .loadProfile)
                    .response()
                
                return response
            }, loadPreActivities: {
                let response: PreActivityResponse = try await tokenNetworkClient
                    .request(endpoint: .loadPreActivities)
                    .response()
                
                return response
            })
    }()
}
