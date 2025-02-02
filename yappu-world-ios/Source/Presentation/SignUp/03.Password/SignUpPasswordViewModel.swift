//
//  SignUpPasswordViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Observation

import Dependencies

@Observable
final class SignUpPasswordViewModel {
    @ObservationIgnored
    @Dependency(Navigation<LoginPath>.self)
    private var navigation
    
    @ObservationIgnored
    private var signUpInfo: SignUpInfoEntity
    
    init(signUpInfo: SignUpInfoEntity) {
        self.signUpInfo = signUpInfo
    }
    
    var password: String {
        get { signUpInfo.password }
        set { signUpInfo.password = newValue }
    }
    var passwordState: InputState = .default
    
    var confirmPassword: String = ""
    var confirmPasswordState: InputState = .default
    
    func clickNextButton() {
        navigation.push(path: .history(signUpInfo))
    }
    
    func clickBackButton() {
        navigation.pop()
    }
    
    func bodyOnTapGesture() {
        passwordState = .default
    }
}
