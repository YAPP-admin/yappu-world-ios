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
    @Dependency(SignUpHistoryUseCase.self)
    private var useCase
    
    @ObservationIgnored
    private var domain: SignUpHistory
    
    @ObservationIgnored
    var name: String {
        domain.signUpInfo.name
    }
    
    var popupMessage: String?
    
    var currentHistory = RegisterHistory(id: 0, old: false)
    var history: [RegisterHistory] = []
    var codeSheetOpen: Bool = false
    
    // 05. 회원가입 코드 모델
    var signupCodeModel: SignupCodeModel {
        get {
            SignupCodeModel(
                code: domain.signUpInfo.signUpCode ?? ""
            )
        } set {
            domain.signUpInfo.signUpCode = newValue.code
        }
    }
    var signupCodeState: InputState = .default
    
    init(signUpInfo: SignUpInfoEntity) {
        self.domain = SignUpHistory(signUpInfo: signUpInfo)
    }
    
    func appendHistory() {
        let id = domain.signUpInfo.registerHistory.count + 1
        history.append(RegisterHistory(id: id))
    }
    
    func deleteHistory(value: RegisterHistory) {
        if let index = history.firstIndex(where: { $0.id == value.id }) {
            history.remove(at: index)
            
            history.enumerated().forEach { index, item in
                domain.signUpInfo.registerHistory[index].id = index + 1
            }
        }
    }
    
    func clickSheetOpen() {
        codeSheetOpen.toggle()
        signupCodeModel.code = ""
    }
    
    func clickNextButton() async {
        await fetchSignUp()
    }
    
    func clickNonCodeButton() async {
        domain.signUpInfo.signUpCode = nil
        await fetchSignUp()
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}

private extension SignUpHistoryViewModel {
    func fetchSignUp() async {
        domain.signUpInfo.registerHistory.removeAll()
        if domain.signUpInfo.registerHistory.isEmpty {
            domain.signUpInfo.registerHistory.append(currentHistory)
        }
        domain.signUpInfo.registerHistory.append(contentsOf: history)
        do {
            self.domain.signUpInfo.fcmToken = try await useCase.fetchFCMToken()
            self.domain.signUpInfo.deviceAlarmToggle = await useCase.getAuthorizationStatus()
            let response = try await self.useCase.fetchSignUp(domain.signUpInfo)
            //guard response.isSuccess else { return }
            
            navigation.push(path: .complete(isComplete: response.isComplete))
        } catch {
            navigation.popAll()
        }
    }
}
