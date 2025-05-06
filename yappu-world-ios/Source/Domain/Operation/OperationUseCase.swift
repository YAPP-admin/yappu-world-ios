//
//  OperationUseCase.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/4/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct OperationUseCase {
    var loadPositions: @Sendable() async throws -> DefaultResponse<OperationPositionsResponse>?
    var loadUsageInquiry: @Sendable() async throws -> DefaultResponse<OperationLinkResponse>?
    var loadTermsOfService: @Sendable() async throws -> DefaultResponse<OperationLinkResponse>?
    var loadPrivacyPolicy: @Sendable() async throws -> DefaultResponse<OperationLinkResponse>?
    var loadForceUpdate: @Sendable(_ model: OperationForceUpdateRequest) async throws -> DefaultResponse<OperationForceUpdateResponse>?
    var loadActiveGeneration: @Sendable() async throws -> DefaultResponse<OperationActiveGenerationResponse>?
}

extension OperationUseCase: TestDependencyKey {
    static var testValue: OperationUseCase = {
        @Dependency(OperationRepository.self)
        var operationRepository
        
        return OperationUseCase(
            loadPositions: {
                try await operationRepository.loadPositions()
            },
            loadUsageInquiry: {
                try await operationRepository.loadUsageInquiry()
            },
            loadTermsOfService: {
                try await operationRepository.loadTermsOfService()
            },
            loadPrivacyPolicy: {
                try await operationRepository.loadPrivacyPolicy()
            },
            loadForceUpdate: { model in
                try await operationRepository.loadForceUpdate(model: model)
            },
            loadActiveGeneration: {
                try await operationRepository.loadActiveGeneration()
            }
        )
    }()
}
