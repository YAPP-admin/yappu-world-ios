//
//  HomeUseCase+LiveKey.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import Foundation
import Dependencies

extension HomeUseCase: DependencyKey {
    static var liveValue: HomeUseCase {
        @Dependency(HomeRepository.self)
        var homeRepository
        
        return HomeUseCase(loadProfile: homeRepository.loadProfile,
                           loadUpcomingSession: homeRepository.loadUpcomingSession,
                           fetchAttendance: homeRepository.fetchAttendance)
    }
}
