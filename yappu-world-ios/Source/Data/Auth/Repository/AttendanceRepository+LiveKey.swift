//
//  AttendanceRepository+LiveKey.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation
import Dependencies

extension AttendanceRepository: DependencyKey {
    static var liveValue: AttendanceRepository = {
        let networkClient = NetworkClient<AttendanceEndPoint>.build()
        
        return AttendanceRepository(
            loadStatistics: {
                let response: DefaultResponse<AttendanceStatisticResponse>? = try await networkClient.request(endpoint: .loadStatistics)
                    .response()
                
                return response
            },
            loadHistory: {
                let response: DefaultResponse<AttendanceHistoriesResponse>? = try await networkClient.request(endpoint: .loadHistory)
                    .response()
                
                return response
            }
        )
    }()
}
