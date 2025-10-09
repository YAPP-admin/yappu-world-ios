//
//  OperationLinkResponse.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/4/25.
//

import Foundation

struct OperationLinkResponse: Decodable {
    let link: String
}

extension OperationLinkResponse {
    func toEntity() -> LinkEntity {
        .init(link: link)
    }
}
