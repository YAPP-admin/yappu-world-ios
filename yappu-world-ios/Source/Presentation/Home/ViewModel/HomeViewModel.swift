//
//  HomeViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import Foundation
import Combine
import SwiftUI
import Dependencies

@Observable
class HomeViewModel {
    @ObservationIgnored
    @Dependency(Navigation<HomePath>.self)
    private var navigation
    
    @ObservationIgnored
    @Dependency(HomeUseCase.self)
    private var useCase
    
    var profile: Profile? = nil
    
    
    func onAppear() async throws {
        try await loadProfile()
    }
    
    func clickNoticeList() {
        navigation.push(path: .noticeList)
    }
    
    func clickNoticeDetail() {
        navigation.push(path: .noticeDetail)
    }
    
    func clickSetting() {
        navigation.push(path: .setting)
    }
}

private extension HomeViewModel {
    private func loadProfile() async throws {
        let profileResponse = try await useCase.loadProfile()
        
        await MainActor.run {
            self.profile = profileResponse.data
        }
    }
}
