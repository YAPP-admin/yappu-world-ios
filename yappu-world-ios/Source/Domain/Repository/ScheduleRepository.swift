//
//  ScheduleRepository.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct ScheduleRepository {
    var loadSchedules: @Sendable(
        _ model: SchedulesReqeust
    ) async throws -> DefaultResponse<SchedulesResponse>?
}

extension ScheduleRepository: TestDependencyKey {
    static var testValue: ScheduleRepository = {
        return ScheduleRepository(
            loadSchedules: { _ in return nil }
        )
    }()
}
