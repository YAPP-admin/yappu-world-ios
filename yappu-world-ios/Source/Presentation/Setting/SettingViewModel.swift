//
//  SettingViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/13/25.
//

import Foundation
import Observation

import Dependencies

@Observable
final class SettingViewModel {
    @ObservationIgnored
    @Dependency(Navigation<TabViewGlobalPath>.self)
    private var navigation
    @ObservationIgnored
    @Dependency(SettingUseCase.self)
    private var useCase
    
    var showWithdrawAlert = false
    var showLogoutAlert = false
    var isMasterEnabled = false
    
    @MainActor
    func onTask() async {
        do {
            let deviceToggle = await useCase.getAuthorizationStatus()
            try await useCase.fetchDevice(deviceToggle)
            let alarms = try await useCase.fetchAlarms()
            isMasterEnabled = alarms.isMasterEnabled
        } catch {
            await MainActor.run {
                YPGlobalPopupManager.shared.show()
            }
        }
    }
    
    func clickWithdrawCell() {
        showWithdrawAlert = true
    }
    
    func clickLogoutButton() {
        showLogoutAlert = true
    }
    
    func clickBackButton() {
        navigation.pop()
    }
    
    @MainActor
    func bindingAlertToggle() async {
        do {
            isMasterEnabled = try await useCase.fetchMaster().isEnabled
        } catch {
            print(error)
        }
    }
    
    func clickWithdrawAlertConfirm() async {
        do {
            try await useCase.deleteUser()
            navigation.switchFlow(.login)
        } catch {
            print(error)
        }
    }
    
    func clickLogoutAlertConfirm() async {
        do {
            try await useCase.deleteToken()
            navigation.switchFlow(.login)
        } catch {
            print(error)
        }
    }
    
    func clickPrivacyPolicyCell() {
        guard
            let url = OperationManager.개인정보_처리방침_URL.secureURL
        else { return }
        navigation.push(path: .safari(url: url))
    }
    
    func clickTermsCell() {
        guard
            let url = OperationManager.서비스_이용약관_URL.secureURL
        else { return }
        navigation.push(path: .safari(url: url))
    }
    
    func clickContactUsCell() {
        guard let url = OperationManager.카카오톡_채널_URL.secureURL else {
            return
        }
        navigation.push(path: .safari(url: url))
    }
}
