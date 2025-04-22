//
//  HomeUseCase.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct HomeUseCase {
    var loadProfile: @Sendable() async throws -> ProfileResponse
    var loadUpcomingSession: @Sendable() async throws -> UpcomingSessionResponse
    var fetchAttendance: @Sendable(_ model: AttendanceRequest) async throws -> AttendanceResponse?
}

extension HomeUseCase: TestDependencyKey {
    static var testValue: HomeUseCase = {
        @Dependency(HomeRepository.self)
        var homeRepository
        
        return HomeUseCase(loadProfile: homeRepository.loadProfile,
                           loadUpcomingSession: homeRepository.loadUpcomingSession,
                           fetchAttendance: homeRepository.fetchAttendance
        )
    }()
}
