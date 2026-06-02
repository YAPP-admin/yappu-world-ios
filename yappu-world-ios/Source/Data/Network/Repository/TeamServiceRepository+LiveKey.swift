//
//  TeamServiceRepository+LiveKey.swift
//  yappu-world-ios
//
//  Created by 김도형 on 6/2/26.
//

import Foundation
import Dependencies

extension TeamServiceRepository: DependencyKey {
    static var liveValue: TeamServiceRepository = {
        let networkClient = NetworkClient<TeamServiceEndPoint>.build()

        return TeamServiceRepository(
            loadServices: { request in
                let response: DefaultResponse<TeamServicePageDTO> = try await networkClient
                    .request(endpoint: .loadServices(request))
                    .response()

                return response
            },
            loadServiceDetail: { serviceId in
                let response: TeamServiceDetailResponse = try await networkClient
                    .request(endpoint: .loadServiceDetail(serviceId))
                    .response()

                return response
            },
            loadUserProfile: { userId in
                let response: DefaultResponse<UserPersonProfileResponse> = try await networkClient
                    .request(endpoint: .loadUserProfile(userId))
                    .response()

                return response
            }
        )
    }()
}
