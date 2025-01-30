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
    @Dependency(NavigationRouter<LoginPath>.self)
    private var loginRouter
    
    var email: String = ""
    var emailState: InputState = .default
    var emailDisabled: Bool {
        return email.isEmpty
    }
    
    func clickNextButton() {
        loginRouter.push(path: .password)
    }
    
    func clickBackButton() {
        loginRouter.pop()
    }
}
