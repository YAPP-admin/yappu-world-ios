//
//  SignUpRootViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/12/25.
//

import Foundation
import Observation
import Combine

import Dependencies

@Observable
class LoginNavigationRouter {
    @ObservationIgnored
    @Dependency(Navigation<LoginPath>.self)
    private var navigation
    
    var path: [LoginPath] = []
    
    @ObservationIgnored
    var viewModel: LoginViewModel
    @ObservationIgnored
    var signUpNameViewModel: SignUpNameViewModel?
    @ObservationIgnored
    var signUpEmailViewModel: SignUpEmailViewModel?
    @ObservationIgnored
    var signUpPasswordViewModel: SignUpPasswordViewModel?
    @ObservationIgnored
    var signUpHistoryViewModel: SignUpHistoryViewModel?
    @ObservationIgnored
    var signUpCompleteViewModel: SignUpCompleteViewModel?
    
    init() {
        self.viewModel = .init()
    }
    
    deinit {
        navigation.cancelBag()
    }
    
    func onAppear() async {
        await pathSubscribe()
    }
    
    private func push(_ path: LoginPath) {
        switch path {
        case .name:
            signUpNameViewModel = .init()
        case .email:
            signUpEmailViewModel = .init()
        case .password:
            signUpPasswordViewModel = .init()
        case .history:
            guard
                let email = signUpEmailViewModel?.email,
                let password = signUpPasswordViewModel?.password,
                let name = signUpNameViewModel?.name
            else { break }
            signUpHistoryViewModel = SignUpHistoryViewModel(
                email: email,
                password: password,
                name: name
            )
        case let .complete(isComplete):
            let signUpComplete = SignupCompleteModel(
                signUpState: isComplete ? .complete : .standby
            )
            signUpCompleteViewModel = .init(signupCompleteModel: signUpComplete)
        }
        self.path.append(path)
    }
    
    @MainActor
    private func pathSubscribe() async {
        for await action in navigation.publisher() {
            switch action {
            case let .push(path):
                self.push(path)
            case .pop:
                path.removeLast()
            case .popAll:
                path.removeAll()
            case .switchRoot:
                // TODO: 루트 네비게이션 변경
                break
            }
        }
    }
}
