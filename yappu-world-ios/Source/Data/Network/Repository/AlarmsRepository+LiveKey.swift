//
//  AlarmsRepository+LiveKey.swift
//  yappu-world-ios
//
//  Created by 김도형 on 3/17/25.
//

import Foundation

import Dependencies

extension AlarmsRepository: DependencyKey {
    static let liveValue = {
        let networkClient = NetworkClient<AlarmsEndPoint>.build()
        
        return AlarmsRepository(
            fetchDevice: { deviceToggle in
                let request = DeviceAlarmRequest(deviceToggle: deviceToggle)
                try await networkClient
                    .request(endpoint: .fetchDevice(request))
                    .response()
            },
            fetchMaster: {
                let response: AlarmsDTO<MasterResponse> = try await networkClient
                    .request(endpoint: .fetchMaster)
                    .response()
                
                return response.data.toEntity()
            },
            fetchAlarms: {
                let response: AlarmsDTO<AlarmsResponse> = try await networkClient
                    .request(endpoint: .fetchAlarms)
                    .response()
                
                return response.data.toEntity()
            }
        )
    }()
}
