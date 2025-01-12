//
//  SignUpRootViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/12/25.
//

import Observation

@Observable
class SignUpNavigationRouter {
    var path: [Path] = []
    
    @ObservationIgnored
    var viewModel: SignUpCodeViewModel
    
    init(viewModel: SignUpCodeViewModel) {
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

extension SignUpNavigationRouter: SignUpCodeViewModelDelegate {
    func clickNextButton(_ viewModel: SignUpCodeViewModel) {
        let completeViewModel = SignUpCompleteViewModel(model: .init(signUpState: .standby))
        push(.complete(viewModel: completeViewModel))
    }
}

extension SignUpNavigationRouter {
    enum Path: Hashable {
        case code(viewModel: SignUpCodeViewModel)
        case complete(viewModel: SignUpCompleteViewModel)
    }
}
