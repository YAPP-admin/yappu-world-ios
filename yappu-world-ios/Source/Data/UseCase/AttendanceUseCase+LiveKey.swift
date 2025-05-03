//
//  AttendanceUseCase+LiveKey.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation
import Dependencies

extension AttendanceUseCase: DependencyKey {
    static var liveValue: AttendanceUseCase = {
        let networkClient = NetworkClient<AttendanceEndPoint>.build()
        
        return AttendanceUseCase(
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
