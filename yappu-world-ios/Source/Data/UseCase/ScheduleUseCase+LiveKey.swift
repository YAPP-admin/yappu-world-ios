//
//  ScheduleUseCase+LiveKey.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import Foundation
import Dependencies

extension ScheduleUseCase: DependencyKey {
    static var liveValue: ScheduleUseCase = {
        @Dependency(ScheduleRepository.self)
        var scheduleRepository
        
        return ScheduleUseCase(
            loadSchedules: scheduleRepository.loadSchedules(model:)
        )
    }()
}
