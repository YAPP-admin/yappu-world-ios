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
    @Dependency(NavigationRouter<LoginPath>.self)
    private var loginRouter
    
    var password: String = ""
    var passwordState: InputState = .default
    
    var confirmPassword: String = ""
    var confirmPasswordState: InputState = .default
    
    func clickNextButton() {
        loginRouter.push(path: .history)
    }
    
    func clickBackButton() {
        loginRouter.pop()
    }
    
    func bodyOnTapGesture() {
        passwordState = .default
    }
}
