//
//  TeamServiceRepository.swift
//  yappu-world-ios
//
//  Created by 김도형 on 6/2/26.
//

import Dependencies
import DependenciesMacros

@DependencyClient
struct TeamServiceRepository {
    var loadServices: @Sendable (
        _ request: TeamServiceRequest
    ) async throws -> DefaultResponse<TeamServicePageDTO>?
    var loadServiceDetail: @Sendable (
        _ serviceId: String
    ) async throws -> TeamServiceDetailResponse?
    var loadUserProfile: @Sendable (
        _ userId: String
    ) async throws -> DefaultResponse<UserPersonProfileResponse>?
}

extension TeamServiceRepository: TestDependencyKey {
    static let testValue = TeamServiceRepository()
}
