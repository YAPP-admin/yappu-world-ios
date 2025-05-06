//
//  AttendanceRepository.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct AttendanceRepository {
    var loadStatistics: @Sendable() async throws -> DefaultResponse<AttendanceStatisticResponse>?
    var loadHistory: @Sendable() async throws -> DefaultResponse<AttendanceHistoriesResponse>?
}

extension AttendanceRepository: TestDependencyKey {
    static var testValue: AttendanceRepository = {
        return AttendanceRepository(
            loadStatistics: { return nil },
            loadHistory: { return nil }
        )
    }()
}
