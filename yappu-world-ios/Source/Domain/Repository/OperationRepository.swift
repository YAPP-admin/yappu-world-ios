//
//  OperationRepository.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/4/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct OperationRepository {
    var loadPositions: @Sendable() async throws -> DefaultResponse<OperationPositionsResponse>?
    var loadUsageInquiry: @Sendable() async throws -> DefaultResponse<OperationLinkResponse>?
    var loadTermsOfService: @Sendable() async throws -> DefaultResponse<OperationLinkResponse>?
    var loadPrivacyPolicy: @Sendable() async throws -> DefaultResponse<OperationLinkResponse>?
    var loadForceUpdate: @Sendable(_ model: OperationForceUpdateRequest) async throws -> DefaultResponse<OperationForceUpdateResponse>?
    var loadActiveGeneration: @Sendable() async throws -> DefaultResponse<OperationActiveGenerationResponse>?
}

extension OperationRepository: TestDependencyKey {
    static var testValue: OperationRepository = {
        return OperationRepository(
            loadPositions: { return nil },
            loadUsageInquiry: { return nil },
            loadTermsOfService: { return nil },
            loadPrivacyPolicy: { return nil },
            loadForceUpdate: { _ in return nil },
            loadActiveGeneration: { return nil }
        )
    }()
}
