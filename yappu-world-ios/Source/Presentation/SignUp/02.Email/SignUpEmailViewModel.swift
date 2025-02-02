//
//  SignUpEmailViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Observation

import Dependencies

@Observable
final class SignUpEmailViewModel {
    @ObservationIgnored
    @Dependency(Navigation<LoginPath>.self)
    private var navigation
    
    @ObservationIgnored
    private var domain: SignUpEmail
    
    init(signUpInfo: SignUpInfoEntity) {
        domain = SignUpEmail(signUpInfo: signUpInfo)
    }
    
    var email: String {
        get { domain.signUpInfo.email }
        set { domain.signUpInfo.email = newValue }
    }
    var emailState: InputState = .default
    var emailDisabled: Bool {
        return email.isEmpty
    }
    
    func clickNextButton() {
        navigation.push(path: .password(domain.signUpInfo))
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}
