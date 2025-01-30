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
    typealias RegisterHistory = SignUpInfoEntity.RegisterHistory
    
    @ObservationIgnored
    @Dependency(Navigation<LoginPath>.self)
    private var navigation
    
    @ObservationIgnored
    private var domain: SignUpHistory
    
    @ObservationIgnored
    var name: String {
        domain.signUpInfo.name
    }
    
    var currentHistory = RegisterHistory(
        id: 0,
        old: false,
        generation: "",
        position: nil,
        state: .default
    )
    var history: [RegisterHistory] {
        get { domain.signUpInfo.registerHistory }
        set { domain.signUpInfo.registerHistory = newValue }
    }
    var codeSheetOpen: Bool = false
    
    // 05. 회원가입 코드 모델
    var signupCodeModel: SignupCodeModel = .init()
    var signupCodeState: InputState = .default
    
    init(
        email: String,
        password: String,
        name: String
    ) {
        self.domain = SignUpHistory(signUpInfo: SignUpInfoEntity(
            email: email,
            password: password,
            name: name
        ))
    }
    
    func appendHistory() {
        let id = domain.signUpInfo.registerHistory.count + 1
        domain.signUpInfo.registerHistory.append(.init(id: id, old: true, generation: "", state: .default))
    }
    
    func deleteHistory(value: RegisterHistory) {
        if let index = history.firstIndex(where: { $0.id == value.id }) {
            domain.signUpInfo.registerHistory.remove(at: index)
            
            domain.signUpInfo.registerHistory.enumerated().forEach { index, item in
                domain.signUpInfo.registerHistory[index].id = index + 1
            }
        }
    }
    
    func clickSheetOpen() {
        codeSheetOpen.toggle()
        signupCodeModel.code = ""
    }
    
    func clickNextButton() {
        navigation.push(path: .complete(isComplete: true))
    }
    
    func clickNonCodeButton() {
        navigation.push(path: .complete(isComplete: false))
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}
