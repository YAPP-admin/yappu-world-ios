//
//  OperationForceUpdateResponse.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/4/25.
//

import Foundation

struct OperationForceUpdateResponse: Decodable {
    var needForceUpdate: Bool
}

extension OperationForceUpdateResponse {
    func toEntity() -> ForceUpdateEntity {
        .init(needForceUpdate: needForceUpdate)
    }
}
