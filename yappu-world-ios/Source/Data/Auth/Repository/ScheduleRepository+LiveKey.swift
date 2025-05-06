//
//  ScheduleRepository+LiveKey.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import Foundation
import Dependencies

extension ScheduleRepository: DependencyKey {
    static var liveValue: ScheduleRepository = {
        let networkClient = NetworkClient<ScheduleEndPoint>.build()
        
        return ScheduleRepository(
            loadSchedules: { model in
                let response: DefaultResponse<SchedulesResponse>? = try await networkClient
                    .request(endpoint: .loadSchedules(model))
                    .response()
                
                return response
            }
        )
    }()
}
