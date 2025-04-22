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
    var upcomingSession: UpcomingSession? = nil

    var noticeList: [NoticeEntity] = [.loadingDummy(), .loadingDummy(), .loadingDummy()]
    
    var isAttendDisabled: Bool = false
    
    var isSheetOpen: Bool = false
    var otpText: String = ""
    var otpState: InputState = .typing
    var isInvalid: Bool = false
    var otpCount: Int = 4
    
    var isLoading: Bool {
       profile == nil
    }
    
    func resetState() {
        profile = nil
        upcomingSession = nil
    }
    
    func onTask() async throws {
        do {
            try await loadProfile()
            try await loadNoticeList()
            try await loadUpcomingSession()
        } catch(let error as YPError) {
            switch error.errorCode {
            case "SCH_1005": // 예정된 세션이 존재하지 않습니다
                upcomingSession = nil
            default:
                self.profile = .dummy()
                self.noticeList = []
            }
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
    
    func clickSheetToggle() {
        isSheetOpen.toggle()
    }
    
    func clickBackButton() {
        navigation.pop()
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
    
    private func loadUpcomingSession() async throws {
        
        guard upcomingSession == nil else { return }

        let upcomingSessionsResponse = try await useCase.loadUpcomingSession()
        
        await MainActor.run {
            self.upcomingSession = upcomingSessionsResponse.data
        }
    }
}
