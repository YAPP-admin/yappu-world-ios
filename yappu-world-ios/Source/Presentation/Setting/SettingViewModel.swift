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
    
    var showWithdrawAlert = false
    var showLogoutAlert = false
    
    func clickWithdrawCell() {
        showWithdrawAlert = true
    }
    
    func clickLogoutButton() {
        showLogoutAlert = true
    }
    
    func clickBackButton() {
        navigation.pop()
    }
    
    func clickWithdrawAlertConfirm() {
        navigation.switchFlow(.home)
    }
    
    func clickLogoutAlertConfirm() {
        navigation.switchFlow(.home)
    }
}
