//
//  SignUpEmailViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Observation

import Dependencies

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
    
    init(signUpInfo: SignUpInfoEntity) {
        domain = SignUpEmail(signUpInfo: signUpInfo)
    }
    
    var email: String {
        get { domain.signUpInfo.email }
        set { domain.signUpInfo.email = newValue }
    }
    var emailState: InputState = .default
    var emailDisabled: Bool {
        return email.isEmpty
    }
    
    func clickNextButton() {
        fetchCheckEmail()
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}

private extension SignUpEmailViewModel {
    func fetchCheckEmail() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let isSuccess = try await useCase.fetchCheckEmail(
                    model: domain.signUpInfo.email
                )
                guard isSuccess else { return }
                navigation.push(path: .password(domain.signUpInfo))
            } catch {
                guard let ypError = error as? YPError else { return }
                emailState = .error(ypError.message)
            }
        }
    }
}
