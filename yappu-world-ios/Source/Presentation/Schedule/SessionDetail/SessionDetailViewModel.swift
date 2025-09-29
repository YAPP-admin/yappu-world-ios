//
//  SessionDetailViewModel.swift
//  yappu-world-ios
//
//  Created by 김건형 on 9/26/25.
//

import Foundation
import SwiftUI
import Dependencies
import DependenciesMacros

@Observable
class SessionDetailViewModel {
    @ObservationIgnored
    @Dependency(Navigation<TabViewGlobalPath>.self)
    var navigation
    
    @ObservationIgnored
    @Dependency(\.userStorage)
    private var userStorage
    
    @ObservationIgnored
    @Dependency(NoticeUseCase.self)
    private var useCase
    
    var id: String // 세션 Id
    var scheduleEntity: ScheduleEntity? = .dummy()

    init(id: String) {
        self.id = id
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}
// MARK: - Private Async Methods
private extension SessionDetailViewModel {
}
