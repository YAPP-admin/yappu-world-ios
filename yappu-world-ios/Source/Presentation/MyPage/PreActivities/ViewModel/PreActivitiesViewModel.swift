//
//  PreActivitiesViewModel.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@Observable
class PreActivitiesViewModel {
    @ObservationIgnored
    @Dependency(Navigation<TabViewGlobalPath>.self)
    var navigation
    
    @ObservationIgnored
    @Dependency(\.userStorage)
    private var userStorage
    
    @ObservationIgnored
    @Dependency(MyPageUseCase.self)
    private var useCase
    
    var activities: [PreActivityEntity] = []
    var isLoading: Bool = true
    
    // 뒤로가기
    func clickBackButton() {
        navigation.pop()
    }
}
// MARK: - Extension async Methods
extension PreActivitiesViewModel {
    func onTask() async throws {
        let value = try await useCase.loadPreActivities()
        
        await MainActor.run {
            activities = value.data.activityUnits
            isLoading = false
        }
    }
    
    func errorAction() async {
        await MainActor.run {
            activities = []
            isLoading = false
        }
    }
}
