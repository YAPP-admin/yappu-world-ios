//
//  OperationPositionsResponse.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/4/25.
//

import Foundation

struct OperationPositionsResponse: Decodable {
    var positions: [OperationPositionResponse]
}

struct OperationPositionResponse: Decodable {
    var name: String
    var label: String
}

extension OperationPositionResponse {
    func toEntity() -> PositionEntity {
        .init(name: name, label: label)
    }
}
