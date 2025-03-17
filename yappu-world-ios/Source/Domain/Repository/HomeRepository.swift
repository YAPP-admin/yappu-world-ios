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
}

extension HomeRepository: TestDependencyKey {
    static var testValue: HomeRepository = {
        @Dependency(HomeRepository.self)
        var homeRepository
        return HomeRepository(loadProfile: homeRepository.loadProfile)
    }()
}
