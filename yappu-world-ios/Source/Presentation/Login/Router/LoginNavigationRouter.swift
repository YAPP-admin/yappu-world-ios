//
//  SignUpRootViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/12/25.
//

import Foundation
import Observation
import Combine

/// 라우터 위치
enum RouterPath: Hashable {
    case name
    case email
    case password
    case code
    case complete
}

// 공통 프로토콜 정의
protocol NavigationActionable {
    var clickNext: PassthroughSubject<RouterPath, Never> { get }
    var clickPopupNext: PassthroughSubject<Void, Never> { get }
}

extension LoginNavigationRouter: NavigationActionable {}

@Observable
class LoginNavigationRouter {
    var path: [RouterPath] = []
    var clickNext: PassthroughSubject<RouterPath, Never> = PassthroughSubject<RouterPath, Never>()
    var clickPopupNext: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    
    private var cancelBag = CancelBag()
    
    @ObservationIgnored
    var viewModel: LoginViewModel
    var signupViewModel: SignupViewModel
    
    init() {
        self.viewModel = .init()
        self.signupViewModel = .init()
        
        self.viewModel.navigation = self
        self.signupViewModel.navigation = self
        
        self.bind()
    }
    
    private func push(_ path: RouterPath) {
        self.path.append(path)
    }
    
    private func pop() {
        self.path.removeLast()
    }
    
    private func popAll() {
        self.path.removeAll()
    }
    
    private func bind() {
        clickNext
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] path in
                self?.push(path)
            })
            .store(in: cancelBag)
        
        clickPopupNext
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.push(.name)
            })
            .store(in: cancelBag)
    }
}
