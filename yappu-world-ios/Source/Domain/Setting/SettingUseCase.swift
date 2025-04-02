//
//  SettingUseCase.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/28/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct SettingUseCase {
    var deleteUser: () async throws ->  Void
    var deleteToken: () async throws ->  Void
    var fetchDevice: (Bool) async throws -> Void
    var fetchMaster: () async throws -> AlarmsMasterEntity
    var fetchAlarms: () async throws -> AlarmsEntity
    var getAuthorizationStatus: () async -> Bool = { false }
}

extension SettingUseCase: TestDependencyKey {
    static let testValue = {
        @Dependency(AuthRepository.self)
        var authRepository
        @Dependency(AlarmsRepository.self)
        var alarmsRepository
        @Dependency(NotificationRepository.self)
        var notificationRepository
        
        return SettingUseCase(
            deleteUser: authRepository.deleteUser,
            deleteToken: authRepository.deleteToken,
            fetchDevice: alarmsRepository.fetchDevice,
            fetchMaster: alarmsRepository.fetchMaster,
            fetchAlarms: alarmsRepository.fetchAlarms,
            getAuthorizationStatus: notificationRepository.getAuthorizationStatus
        )
    }()
}
