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
                if error.errorCode == "USR_1101" { // 이메일이 다르거나 존재하지 않는 계정
                    emailState = .error("입력하신 이메일을 확인해주세요.")
                } else if error.errorCode == "USR_1102" { // 회원가입 대기중
                    navigation.push(path: .complete(isComplete: false))
                } else if error.errorCode == "USR_1105" || error.errorCode == "COM_0002" { // 비밀번호 다를 때
                    passwordState = .error("비밀번호가 달라요. 입력하신 비밀번호를 확인해주세요.")
                } else { // 그 외
                    passwordState = .error(error.message)
                }
            }
        }
    }
}
