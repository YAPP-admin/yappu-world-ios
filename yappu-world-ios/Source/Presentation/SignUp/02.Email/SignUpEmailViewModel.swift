//
//  SignUpEmailViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Observation
import Combine
import Dependencies
import UIKit
import SwiftUI

@Observable
final class SignUpEmailViewModel {
    @ObservationIgnored
    @Dependency(Navigation<LoginPath>.self)
    private var navigation
    
    @ObservationIgnored
    @Dependency(SignUpEmailUseCase.self)
    private var useCase
    
    @ObservationIgnored
    private var domain: SignUpEmail
    
    @ObservationIgnored
    private var cancelBag: CancelBag = CancelBag()
    
    @ObservationIgnored
    private var animationDuration: CGFloat = 0.5
    
    init(signUpInfo: SignUpInfoEntity) {
        domain = SignUpEmail(signUpInfo: signUpInfo)
    }
    
    private var debounceTask: Task<Void, Never>? = nil
    var emailTypingText: String = ""
    
    var email: String {
        get { domain.signUpInfo.email }
        set { domain.signUpInfo.email = newValue }
    }
    var emailState: InputState = .default
    
    var emailDisabled: Bool = true
    
    // searchText가 변경될 때마다 호출될 메서드
    func textChanged() {
        
        withAnimation(.smooth(duration: animationDuration)) {
            emailState = .typing
        }
        
        debounceTask?.cancel()
        
        if emailTypingText.isEmpty {
            withAnimation(.smooth(duration: animationDuration)) {
                emailState = .default
            }
            emailDisabled = (isValidEmail(email) && emailState == .success("사용 가능한 이메일이에요!")).not()
            return
        }
        
        debounceTask = Task {
            do {
                
                try await Task.sleep(for: .milliseconds(400))
                
                if !Task.isCancelled {
                    await MainActor.run {
                        email = emailTypingText
                    }
                    
                    await fetchCheckEmail()
                }
            } catch {
                print("--- Cancel Task Success ---")
            }
        }
    }
    
    func clickNextButton() async {
        await moveToNext()
    }
    
    func clickBackButton() {
        navigation.pop()
    }
    
    func moveToNext() async {
        await MainActor.run {
            navigation.push(path: .password(domain.signUpInfo))
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }
}

private extension SignUpEmailViewModel {
    func fetchCheckEmail() async {
        do {
            let isSuccess = try await useCase.fetchCheckEmail(
                model: domain.signUpInfo.email
            )
            guard isSuccess else { return }
            
            if isValidEmail(email) {
                withAnimation(.smooth(duration: animationDuration)) {
                    emailState = .success("사용 가능한 이메일이에요!")
                }
                emailDisabled = false
            } else {
                withAnimation(.smooth(duration: animationDuration)) {
                    emailState = .error("올바르지 않은 이메일 형식이에요. 다시 입력해주세요.")
                }
                
                emailDisabled = true
            }
            
        } catch {
            guard let ypError = error as? YPError else { return }
            withAnimation(.smooth(duration: animationDuration)) {
                emailState = .error(ypError.message)
            }
        }
    }
}
