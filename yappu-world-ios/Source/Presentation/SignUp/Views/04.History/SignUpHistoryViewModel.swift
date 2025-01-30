//
//  SignUpHistoryViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import SwiftUI

import Dependencies

@Observable
final class SignUpHistoryViewModel {
    @ObservationIgnored
    @Dependency(NavigationRouter<LoginPath>.self)
    private var loginRouter
    
    @ObservationIgnored
    let name: String
    
    var currentHistory = RegisterHistoryEntity(
        id: 0,
        old: false,
        generation: "",
        position: nil,
        state: .default
    )
    var history: [RegisterHistoryEntity] = []
    var codeSheetOpen: Bool = false
    
    // 05. 회원가입 코드 모델
    var signupCodeModel: SignupCodeModel = .init()
    var signupCodeState: InputState = .default
    
    init(name: String) {
        self.name = name
    }
    
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
    
    func clickSheetOpen() {
        codeSheetOpen.toggle()
        signupCodeModel.code = ""
    }
    
    func clickNextButton() {
        loginRouter.push(path: .complete)
    }
    
    func clickBackButton() {
        loginRouter.pop()
    }
}
