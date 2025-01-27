//
//  RegisterMainViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/14/25.
//

import Foundation


@Observable
class SignupViewModel: NSObject {
    
    var navigation: NavigationActionable?
    
    var name: String = "dsadas"
    var nameState: InputState = .default
    var nameDisabled: Bool {
        return name.isEmpty
    }
    
    var email: String = ""
    var emailState: InputState = .default
    var emailDisabled: Bool {
        return email.isEmpty
    }
    
    var password: String = ""
    var passwordState: InputState = .default
    
    var confirmPassword: String = ""
    var confirmPasswordState: InputState = .default
    
    // 05. 회원가입 코드 모델
    var signupCodeModel: SignupCodeModel = .init()
    
    // 06. 회원가입 확인 여부 모델
    var signupCompleteModel: SignupCompleteModel = .init(signUpState: .standby)
    
    var history: [RegisterHistoryEntity] = [RegisterHistoryEntity.init(id: 0, generation: "", position: nil)]
    
    
    func clickNextButton(path: RouterPath) {
        navigation?.clickNext.send(path)
    }
}

