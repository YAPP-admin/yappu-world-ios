//
//  MyPageViewModel.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@Observable
class MyPageViewModel {
    @ObservationIgnored
    @Dependency(Navigation<MyPagePath>.self)
    var navigation
    
    @ObservationIgnored
    @Dependency(\.userStorage)
    private var userStorage
    
    @ObservationIgnored
    @Dependency(MyPageUseCase.self)
    private var useCase
    
    var profile: Profile? = nil
}
// MARK: - Extension async Methods
extension MyPageViewModel {
    func onTask() async throws {
        guard profile == nil else { return }
        
        let profileResponse = try await useCase.loadProfile()
        await self.userStorage.save(user: profileResponse.data)
        await MainActor.run {
            self.profile = profileResponse.data
        }
    }
    
    func clickSetting() {
        navigation.push(path: .setting)
    }
    
    func errorAction() async {
        await MainActor.run {
            self.profile = nil
        }
    }
}
