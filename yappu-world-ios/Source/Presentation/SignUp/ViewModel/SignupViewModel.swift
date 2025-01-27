//
//  RegisterMainViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/14/25.
//

import Foundation
import SwiftUI


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
    var signupCodeState: InputState = .default
    
    // 06. 회원가입 확인 여부 모델
    var signupCompleteModel: SignupCompleteModel = .init(signUpState: .standby)
    var codeSheetOpen: Bool = false
    
    var currentHistory: RegisterHistoryEntity = RegisterHistoryEntity.init(id: 0, old: false, generation: "", position: nil, state: .default)
    
    var history: [RegisterHistoryEntity] = []
    
    func appendHistory() {
        let id = history.count + 1
        history.append(.init(id: id, old: true, generation: "", state: .default))
    }
    
    func deleteHistory(value: RegisterHistoryEntity) {
        if let index = history.firstIndex(where: { $0.id == value.id }) {
            history.remove(at: index)
            
            history.enumerated().forEach { index, item in
                history[index].id = index + 1
            }
        }
    }
    
    func clickNextButton(path: RouterPath) {
        navigation?.clickNext.send(path)
    }
    
    func clickSheetOpen() {
        withAnimation(.smooth(duration: 0.2)) {
            codeSheetOpen.toggle()
        }
        signupCodeModel.code = ""
    }
}

