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
    @Dependency(Navigation<TabViewGlobalPath>.self)
    var navigation
    
    @ObservationIgnored
    @Dependency(\.userStorage)
    private var userStorage
    
    @ObservationIgnored
    @Dependency(MyPageUseCase.self)
    private var useCase
    
    var profile: Profile?
    var showWithdrawAlert = false
    var showLogoutAlert = false
    var isLoading: Bool {
       profile == nil
    }
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
    
    func errorAction() async {
        await MainActor.run {
            self.profile = nil
        }
    }
    
    func clickWithdrawAlertConfirm() async {
        do {
            try await useCase.deleteUser()
            navigation.switchFlow(.login)
        } catch {
            await MainActor.run {
                YPGlobalPopupManager.shared.show()
            }
        }
    }
    
    func clickLogoutAlertConfirm() async {
        do {
            try await useCase.deleteUser()
            navigation.switchFlow(.login)
        } catch {
            await MainActor.run {
                YPGlobalPopupManager.shared.show()
            }
        }
    }
}
// MARK: - Extension Action Methods
extension MyPageViewModel {
    
    func clickSetting() {
        navigation.push(path: .setting)
    }
    
    func clickContactUsCell() {
        guard let url = OperationManager.카카오톡_채널_URL.secureURL else {
            return
        }
        navigation.push(path: .safari(url: url))
    }
    
    func clickMenuCell(item: MyPageMenuView.SettingItem) {
        switch item {
        case .출석내역:
            navigation.push(path: .attendances)
        case .이전활동내역:
            navigation.push(path: .preActivities)
        case .이용문의:
            guard let url = OperationManager.이용_문의_URL.secureURL else {
                return
            }
            navigation.push(path: .safari(url: url))
        case .회원탈퇴:
            showWithdrawAlert = true
        }
    }
    
    func clickLogoutButton() {
        showLogoutAlert = true
    }
}
