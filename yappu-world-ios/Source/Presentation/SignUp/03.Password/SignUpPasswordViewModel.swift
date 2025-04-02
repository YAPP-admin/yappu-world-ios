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
    
    var isValidPassword: Bool {
        password.count > 8 && password == confirmPassword
    }
    
//    private func isValidPassword(_ password: String) -> Bool {
//        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?])[A-Za-z\\d!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]{8,20}$"
//        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
//        return passwordPredicate.evaluate(with: password)
//    }
    
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
