//
//  OperationUseCase+LiveKey.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/4/25.
//

import Foundation
import Dependencies

extension OperationUseCase: DependencyKey {
    static var liveValue: OperationUseCase = {
        @Dependency(OperationRepository.self)
        var operationRepository
        
        return OperationUseCase(
            loadPositions: operationRepository.loadPositions,
            loadUsageInquiry: operationRepository.loadUsageInquiry,
            loadTermsOfService: operationRepository.loadTermsOfService,
            loadPrivacyPolicy: operationRepository.loadPrivacyPolicy,
            loadForceUpdate: operationRepository.loadForceUpdate(model:),
            loadActiveGeneration: operationRepository.loadActiveGeneration
        )
    }()
}
