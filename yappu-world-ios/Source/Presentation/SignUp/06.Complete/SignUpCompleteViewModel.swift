//
//  SignUpCompleteViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Observation

import Dependencies

@Observable
final class SignUpCompleteViewModel {
    @ObservationIgnored
    @Dependency(Navigation<LoginPath>.self)
    private var navigation
    
    // 06. 회원가입 확인 여부 모델
    var signupCompleteModel: SignupCompleteModel
    
    init(signupCompleteModel: SignupCompleteModel) {
        self.signupCompleteModel = signupCompleteModel
    }
    
    func clickNextButton() {
        navigation.switchFlow(.home)
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}
