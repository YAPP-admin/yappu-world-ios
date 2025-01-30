//
//  SignUpRequest.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Foundation

struct SignUpRequest: Encodable {
    let email: String
    let password: String
    let name: String
    let activityUnits: [ActivityUnit]
    let signUpCode: String?
}

extension SignUpRequest {
    struct ActivityUnit: Encodable {
        let generation: Int
        let position: String
    }
}

extension SignUpInfoEntity {
    func toData() -> SignUpRequest {
        return .init(
            email: self.email,
            password: self.password,
            name: self.name,
            activityUnits: self.registerHistory.map { $0.toData() },
            signUpCode: self.signUpCode
        )
    }
}

extension SignUpInfoEntity.RegisterHistory {
    typealias DTOActivityUnit = SignUpRequest.ActivityUnit
    
    func toData() -> DTOActivityUnit {
        return .init(
            generation: Int(self.generation) ?? 0,
            position: self.position?.rawValue ?? ""
        )
    }
}
