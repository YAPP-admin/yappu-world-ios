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
    
    
    var nextButtonText: String = "다음"
    
    // Add this property to your class
    private var isSigningUp = false
    
    // 클래스에 debounce 관련 속성 추가
    private var signUpWorkItem: DispatchWorkItem?

    var signupTask: Task<Void,Error>?

    
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
    
    var buttonDisable: Bool = true
    
    var buttonState: InputState = .default
    
    // 05. 회원가입 코드 모델
    var signupCode: String = ""
    var isSignupCodeButton: Bool = true
    var signupCodeState: InputState = .default
    
    init(signUpInfo: SignUpInfoEntity) {
        self.domain = SignUpHistory(signUpInfo: signUpInfo)
    }
    
    func appendHistory() {
        let id = history.count + 1
        let item = RegisterHistory(id: id)
        history.append(item)
    }
    
    func deleteHistory(value: RegisterHistory) {
        if let index = history.firstIndex(where: { $0.id == value.id }) {
            history.remove(at: index)
            
            history.enumerated().forEach { index, item in
                history[index].id = index + 1
            }
        }
    }
    
    func checkSignupCodeState() {
        signupCodeState = .focus
        isSignupCodeButton = signupCode.isEmpty
    }
    
    func checkIsData() {
        
        let currentDataInGeneration = currentHistory.generation != ""
        let currentDataInPosition = currentHistory.position != nil
        
        if history.isEmpty {
            if currentDataInGeneration && currentDataInPosition {
                buttonDisable = false
            } else {
                buttonDisable = true
            }
        } else {
            
            let dataInGeneration = history.filter({ $0.generation == "" }).isEmpty
            let dataInPosition = history.filter({ $0.position == nil }).isEmpty
            
            if dataInGeneration && dataInPosition && currentDataInGeneration && currentDataInPosition {
                buttonDisable = false
            } else {
                buttonDisable = true
            }
        }
    }
    
    func changeButtonState(value: Bool) {
        withAnimation(.smooth) {
            buttonState = value ? .focus : .default
        }

    }
    
    func clickSheetOpen() {
        codeSheetOpen.toggle()
        signupCode = ""
    }
    
    func clickNonCodeButton() async {
        domain.signUpInfo.signUpCode = nil
        await fetchSignUp()
    }
    
    func clickBackButton() {
        navigation.pop()
    }
    
    
    // debounce 처리가 적용된 함수
    func debouncedFetchSignUp() async {
        
        await MainActor.run {
            codeSheetOpen = false
            nextButtonText = "가입 신청 중"
            buttonDisable = true
        }
        
        await fetchSignUp()
    }
}

private extension SignUpHistoryViewModel {

    
    func fetchSignUp() async {
        domain.signUpInfo.registerHistory.removeAll()
        if domain.signUpInfo.registerHistory.isEmpty {
            domain.signUpInfo.registerHistory.append(currentHistory)
        }
        domain.signUpInfo.registerHistory.append(contentsOf: history)
        domain.signUpInfo.signUpCode = signupCode != "" ? signupCode : nil
        
        do {
            self.domain.signUpInfo.fcmToken = try await useCase.fetchFCMToken()
            self.domain.signUpInfo.deviceAlarmToggle = await useCase.getAuthorizationStatus()
            let response = try await self.useCase.fetchSignUp(domain.signUpInfo)
            codeSheetOpen = false
            navigation.push(path: .complete(isComplete: response.isComplete))
        } catch {
            guard let ypError = error as? YPError else { return }
            signupCodeState = .error(ypError.message)
            isSignupCodeButton = true
            
            if ypError.errorCode == "USR_1003" {
                navigation.push(path: .complete(isComplete: false))
            }
        }
    }
}
