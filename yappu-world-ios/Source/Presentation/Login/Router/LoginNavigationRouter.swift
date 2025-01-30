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

/// 라우터 위치
enum LoginPath: Hashable {
    case name
    case email
    case password
    case history
    case complete
}

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
    
    func onAppear() async {
        await pathSubscribe()
    }
    
    func onDisappear() {
        pathUnsubscribe()
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
