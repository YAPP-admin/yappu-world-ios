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
}

extension HomeUseCase: TestDependencyKey {
    static var testValue: HomeUseCase = {
        @Dependency(HomeRepository.self)
        var homeRepository
        
        return HomeUseCase(loadProfile: homeRepository.loadProfile)
    }()
}
