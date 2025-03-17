//
//  AlarmsRepository.swift
//  yappu-world-ios
//
//  Created by 김도형 on 3/16/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct AlarmsRepository {
    var fetchDevice: (Bool) async throws -> Void
    var fetchMaster: () async throws -> AlarmsMasterEntity
    var fetchAlarms: () async throws -> AlarmsEntity
}

extension AlarmsRepository: TestDependencyKey {
    static let testValue = {
        return AlarmsRepository(
            fetchDevice: { _ in },
            fetchMaster: { .mock },
            fetchAlarms: { .mock }
        )
    }()
}
