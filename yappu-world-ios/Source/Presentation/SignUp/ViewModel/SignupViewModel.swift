//
//  RegisterMainViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/14/25.
//

import Foundation
import SwiftUI

import Dependencies

@Observable
class SignupViewModel: NSObject {
    @ObservationIgnored
    @Dependency(NavigationRouter<LoginPath>.self)
    private var loginRouter
    
    // 06. 회원가입 확인 여부 모델
    var signupCompleteModel: SignupCompleteModel = .init(signUpState: .standby)
    
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
    
    func clickNextButton(path: LoginPath) {
        loginRouter.push(path)
    }
    
    func clickBackButton() {
        loginRouter.pop()
    }
}

