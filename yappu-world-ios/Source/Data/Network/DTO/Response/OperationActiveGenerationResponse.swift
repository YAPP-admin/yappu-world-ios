//
//  OperationActiveGenerationResponse.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/4/25.
//

import Foundation

struct OperationActiveGenerationResponse: Decodable {
    var isActive: Bool
    var generation: Int
}

extension OperationActiveGenerationResponse {
    func toEntity() -> ActiveGenerationEntity {
        .init(isActive: isActive, generation: generation)
    }
}
