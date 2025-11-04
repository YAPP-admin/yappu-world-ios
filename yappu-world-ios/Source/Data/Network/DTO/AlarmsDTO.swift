//
//  AlarmsDTO.swift
//  yappu-world-ios
//
//  Created by 김도형 on 3/16/25.
//

import Foundation

struct AlarmsDTO<Data: Decodable>: Decodable {
    let isSuccess: Bool
    let data: Data
}

struct MasterResponse: Decodable {
    let isEnabled: Bool
}

struct AlarmsResponse: Decodable {
    let isMasterEnabled: Bool
}

extension MasterResponse {
    func toEntity() -> AlarmsMasterEntity {
        return AlarmsMasterEntity(isEnabled: self.isEnabled)
    }
}

extension AlarmsResponse {
    func toEntity() -> AlarmsEntity {
        return AlarmsEntity(isMasterEnabled: self.isMasterEnabled)
    }
}
