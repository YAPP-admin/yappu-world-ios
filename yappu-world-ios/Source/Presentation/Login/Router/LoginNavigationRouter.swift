//
//  SignUpRootViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/12/25.
//

import Observation

@Observable
class LoginNavigationRouter {
    var path: [Path] = []
    
    @ObservationIgnored
    var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    private func push(_ path: Path) {
        self.path.append(path)
    }
    
    private func pop() {
        self.path.removeLast()
    }
    
    private func popAll() {
        self.path.removeAll()
    }
}

extension LoginNavigationRouter: LoginViewModelDelegate {
    func clickPopupNextButton() {
        let viewModel = SignUpCodeViewModel(model: .init())
        viewModel.delegate = self
        push(.code(viewModel: viewModel))
    }
}

extension LoginNavigationRouter: SignUpCodeViewModelDelegate {
    func clickNextButton() {
        let viewModel = SignUpCompleteViewModel(model: .init(signUpState: .standby))
        push(.complete(viewModel: viewModel))
    }
}

extension LoginNavigationRouter {
    enum Path: Hashable {
        case code(viewModel: SignUpCodeViewModel)
        case complete(viewModel: SignUpCompleteViewModel)
    }
}
