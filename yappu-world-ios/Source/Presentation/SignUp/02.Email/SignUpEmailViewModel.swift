//
//  SignUpEmailViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Observation
import Dependencies
import SwiftUI

@Observable
final class SignUpEmailViewModel {
    @ObservationIgnored
    @Dependency(Navigation<LoginPath>.self)
    private var navigation
    
    @ObservationIgnored
    @Dependency(SignUpEmailUseCase.self)
    private var useCase
    
    @ObservationIgnored
    private var domain: SignUpEmail
    
    init(signUpInfo: SignUpInfoEntity) {
        domain = SignUpEmail(signUpInfo: signUpInfo)
    }
    
    var email: String = ""
    var emailState: InputState = .default
    
    var emailDisabled: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: email)
        if email.isEmpty.not() {
            emailState = emailTest ? emailState == .default ? .default : .focus : .error("올바르지 않은 이메일 형식이에요. 다시 입력해주세요.")
        } else {
            emailState = emailState == .default ? .default : .focus
        }
        
        return emailTest.not()
    }
    
    func clickNextButton() async {
        await fetchCheckEmail()
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}

private extension SignUpEmailViewModel {
    func fetchCheckEmail() async {
        do {
            domain.signUpInfo.email = email
            let isSuccess = try await useCase.fetchCheckEmail(
                model: domain.signUpInfo.email
            )
            guard isSuccess else { return }
            navigation.push(path: .password(domain.signUpInfo))
        } catch {
            guard let ypError = error as? YPError else { return }
            emailState = .error(ypError.message)
        }
    }
}
