//
//  LoginViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/4/25.
//

import Foundation
import Combine
import SwiftUI
import Dependencies

@Observable
class LoginViewModel {
    @ObservationIgnored
    @Dependency(Navigation<LoginPath>.self)
    private var navigation
    @ObservationIgnored
    @Dependency(LoginUseCase.self)
    private var useCase
    
    var login = Login()
    var emailState: InputState = .default
    var passwordState: InputState = .default
    
    var isValid: Bool {
        return login.email.isEmpty.not() && login.password.isEmpty.not()
    }
    
    var registerButtonOpen: Bool = false
    
    var serviceBool: Bool = false
    var privacyBool: Bool = false
    var marketingBool: Bool = false
    
    var registerIsValid: Bool {
        return serviceBool && privacyBool
    }
    
    func clickRegisterButton() {
        serviceBool = false
        privacyBool = false
        privacyBool = false
        
        withAnimation {
            registerButtonOpen.toggle()
        }
    }
    
    func clickPopupNextButton() {
        navigation.push(.name)
    }
    
    func clickLoginButton() async {
        await fetchLogin()
    }
}

private extension LoginViewModel {
    func fetchLogin() async {
        let model = LoginEntity(
            email: login.email,
            password: login.password
        )
        do {
            let response = try await useCase.fetchLogin(model: model)
            guard response else { return }
            navigation.switchFlow(.home)
        } catch {
            print(error)
        }
    }
}
