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
    @Dependency(Navigation<TabViewGlobalPath>.self)
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
    
    var noticeList: [NoticeEntity] = [.loadingDummy(), .loadingDummy(), .loadingDummy()]
    
    var isLoading: Bool {
       profile == nil
    }
    
    func resetState() {
        profile = nil
    }
    
    func onTask() async throws {
        do {
            try await loadProfile()
            try await loadNoticeList()
        } catch {
            self.profile = .dummy()
            self.noticeList = []
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
// MARK: - Private Async Methods
private extension HomeViewModel {
    private func loadProfile() async throws {
        
        guard profile == nil else { return }
        
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
