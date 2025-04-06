//
//  SignUpPasswordViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Observation
import Combine
import Dependencies
import Foundation

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
    
    var password: String = ""
    var passwordState: InputState = .default
    
    var confirmPassword: String = ""
    var confirmPasswordState: InputState = .default
    
    var buttonState: InputState = .default
    
    var isValidPassword: Bool = false
    var isValidConfirmPassword: Bool = false
    
    func buttonStateCheck(value: Bool) {
        if value {
            buttonState = .focus
        } else {
            buttonState = .default
        }
    }
    
    func isValidPasswordCheck() {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,20}$"
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        isValidPassword = passwordTest.evaluate(with: password)
        
        if isValidPassword {
            passwordState = .focus
        } else {
            passwordState = .error("비밀번호 설정 조건에 맞지 않아요. 다시 입력 해주세요.")
        }
    }
    
    func isCheckSamePassword() {
        
        isValidConfirmPassword = password == confirmPassword
        
        if password != confirmPassword {
            confirmPasswordState = .error("비밀번호가 일치하지 않습니다.")
        } else {
            confirmPasswordState = .focus
        }
    }
    
    func clickNextButton() {
        signUpInfo.password = confirmPassword
        navigation.push(path: .history(signUpInfo))
    }
    
    func clickBackButton() {
        navigation.pop()
    }
    
    func bodyOnTapGesture() {
        if passwordState != .error("비밀번호 설정 조건에 맞지 않아요. 다시 입력 해주세요.") {
            passwordState = .default
        }

        if confirmPasswordState != .error("비밀번호가 일치하지 않습니다.") {
            passwordState = .default
        }
    }
}
