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
    
    @ObservationIgnored
    @Dependency(NoticeUseCase.self)
    private var noticeUseCase
    
    @ObservationIgnored
    @Dependency(\.userStorage)
    private var userStorage
    
    var profile: Profile? = nil
    
    var noticeList: [NoticeEntity] = []
    
    
    func onAppear() async throws {
        do {
            try await loadProfile()
            try await loadNoticeList()
        } catch {
            print("error", error.localizedDescription)
        }
        
    }
    
    func clickNoticeList() {
        navigation.push(path: .noticeList)
    }
    
    func clickNoticeDetail(id: String) {
        navigation.push(path: .noticeDetail(id: id))
    }
    
    func clickSetting() {
        navigation.push(path: .setting)
    }
}

private extension HomeViewModel {
    private func loadProfile() async throws {
        let profileResponse = try await useCase.loadProfile()
        await self.userStorage.save(user: profileResponse.data)
        await MainActor.run {
            self.profile = profileResponse.data
        }
    }
    
    private func loadNoticeList() async throws {
        
        let noticeResponse = try await noticeUseCase.loadNotices(model: .init(lastCursorId: nil, limit: 3, noticeType: "ALL"))
        await MainActor.run {
            if let notices = noticeResponse?.data {
                self.noticeList = notices.data.map({ $0.toEntity() })
            }
            
        }
    }
}
