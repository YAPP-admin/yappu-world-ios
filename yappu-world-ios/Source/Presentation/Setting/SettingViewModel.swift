//
//  SettingViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/13/25.
//

import Observation

import Dependencies

@Observable
final class SettingViewModel {
    @ObservationIgnored
    @Dependency(Navigation<HomePath>.self)
    private var navigation
    @ObservationIgnored
    @Dependency(SettingUseCase.self)
    private var useCase
    
    var showWithdrawAlert = false
    var showLogoutAlert = false
    var isMasterEnabled = false
    
    @MainActor
    func onAppear() async {
        do {
            let deviceToggle = await useCase.getAuthorizationStatus()
            try await useCase.fetchDevice(deviceToggle)
            let alarms = try await useCase.fetchAlarms()
            isMasterEnabled = alarms.isMasterEnabled
        } catch {
            print(error)
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
}
