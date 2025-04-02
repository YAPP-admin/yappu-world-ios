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
    
    func clickPrivacyPolicyButton() {
        guard
            let url = URL(string: .개인정보_처리방침_URL)
        else { return }
        navigation.push(path: .safari(url: url))
    }
    
    func clickTermsCellButton() {
        guard
            let url = URL(string: .서비스_이용약관_URL)
        else { return }
        navigation.push(path: .safari(url: url))
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
            if let error = error as? YPError {
                passwordState = .error(error.message)
            }
        }
    }
}
