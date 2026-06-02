//
//  TeamServiceUseCase+LiveKey.swift
//  yappu-world-ios
//
//  Created by 김도형 on 6/2/26.
//

import Foundation
import Dependencies

extension TeamServiceUseCase: DependencyKey {
    static var liveValue: TeamServiceUseCase = {
        @Dependency(TeamServiceRepository.self)
        var repository

        return TeamServiceUseCase(
            loadServices: { lastCursorId, limit, generation, platform in
                let request = TeamServiceRequest(
                    lastCursorId: lastCursorId,
                    limit: limit,
                    generation: generation,
                    platform: platform?.apiValue
                )
                let response = try await repository.loadServices(request)
                return response?.data.toEntity() ?? .empty
            },
            loadServiceDetail: { id in
                let response = try await repository.loadServiceDetail(id)
                return response?.toEntity()
            },
            loadMemberProfile: { userId in
                let response = try await repository.loadUserProfile(userId)
                return response?.data.toEntity()
            }
        )
    }()
}
