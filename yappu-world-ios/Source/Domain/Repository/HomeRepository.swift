//
//  HomeRepository.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct HomeRepository {
    var loadProfile: @Sendable() async throws -> ProfileResponse
    var loadUpcomingSession: @Sendable() async throws -> UpcomingSessionResponse
    var fetchAttendance: @Sendable(_ model: AttendanceRequest) async throws -> AttendanceResponse?

}

extension HomeRepository: TestDependencyKey {
    static var testValue: HomeRepository = {
        @Dependency(HomeRepository.self)
        var homeRepository
        
        return HomeRepository(loadProfile: homeRepository.loadProfile,
                              loadUpcomingSession: homeRepository.loadUpcomingSession,
                              fetchAttendance: { _ in return nil }
        )
    }()
}
