//
//  AttendanceUseCase.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct AttendanceUseCase {
    var loadStatistics: @Sendable() async throws -> DefaultResponse<AttendanceStatisticResponse>?
    var loadHistory: @Sendable() async throws -> DefaultResponse<AttendanceHistoriesResponse>?
}

extension AttendanceUseCase: TestDependencyKey {
    static var testValue: AttendanceUseCase = {
        @Dependency(AttendanceRepository.self)
        var attendanceRepository
        
        return AttendanceUseCase(
            loadStatistics: attendanceRepository.loadStatistics,
            loadHistory: attendanceRepository.loadHistory
        )
    }()
}
