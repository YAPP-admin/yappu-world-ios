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
    @Dependency(\.loginRouter)
    private var loginRouter
    
    var path: [LoginPath] = []
    
    @ObservationIgnored
    var viewModel: LoginViewModel
    @ObservationIgnored
    var signupViewModel: SignupViewModel
    
    init() {
        self.viewModel = .init()
        self.signupViewModel = .init()
    }
    
    deinit {
        loginRouter.cancelBag()
    }
    
    func onAppear() async {
        await pathSubscribe()
    }
    
    @MainActor
    private func pathSubscribe() async {
        for await router in loginRouter.publisher() {
            switch router {
            case let .push(path):
                self.path.append(path)
            case .pop:
                path.removeLast()
            case .popAll:
                path.removeAll()
            }
        }
    }
    
    private func pathUnsubscribe() {
        loginRouter.cancelBag()
    }
}
