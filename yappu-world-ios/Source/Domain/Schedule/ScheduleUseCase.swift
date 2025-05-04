//
//  ScheduleUseCase.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct ScheduleUseCase {
    var loadSchedules: @Sendable(_ model: SchedulesReqeust) async throws -> DefaultResponse<SchedulesResponse>?
}

extension ScheduleUseCase: TestDependencyKey {
    static var testValue: ScheduleUseCase = {
        @Dependency(ScheduleRepository.self)
        var scheduleRepository
    
        return ScheduleUseCase(
            loadSchedules: { model in
                try await scheduleRepository.loadSchedules(model)
            }
        )
    }()
}
