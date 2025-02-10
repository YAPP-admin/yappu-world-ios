//
//  SignUpPasswordViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Observation
import Dependencies
import Combine

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
    var isValidPassword: Bool {
        let pattern = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,20}$"
        let isValid: Bool = password.range(of: pattern, options: .regularExpression) != nil
        passwordState = isValid ? passwordState == .focus ? .focus : .default : .error("비밀번호 설정 조건에 맞지 않아요. 다시 입력 해주세요.")
        return isValid.not()
    }
    
    var confirmPassword: String = "" {
        didSet {
            
        }
    }
    var confirmPasswordState: InputState = .default
    var isValidConfirmPassword: Bool {
        print("password, confirmPassword", password, confirmPassword)
        confirmPasswordState = password == confirmPassword ? confirmPasswordState == .focus ? .focus : .default : .error("입력하신 비밀번호와 달라요. 확인후 다시 입력해주세요.")
        return password == confirmPassword
    }
    
    func clickNextButton() {
        signUpInfo.password = confirmPassword
        navigation.push(path: .history(signUpInfo))
    }
    
    func clickBackButton() {
        navigation.pop()
    }
    
    func bodyOnTapGesture() {
        passwordState = .default
    }

}
