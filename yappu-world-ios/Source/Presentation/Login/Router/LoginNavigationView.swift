//
//  SignUpRootView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/12/25.
//


import SwiftUI

struct LoginNavigationView: View {
    @Bindable
    private var router: LoginNavigationRouter
    
    init(router: LoginNavigationRouter) {
        self.router = router
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            LoginView(viewModel: router.viewModel)
                .navigationDestination(for: RouterPath.self) { path in
                    switch path {
                    case .name:
                        SignUpNameView(viewModel: router.signupViewModel)
                            .backButton(router: router)
                    case .email:
                        SignUpEmailView(viewModel: router.signupViewModel)
                            .backButton(router: router)
                    case .password:
                        SignUpPasswordView(viewModel: router.signupViewModel)
                            .backButton(router: router)
                    case .history:
                        SignUpHistoryView(viewModel: router.signupViewModel)
                            .backButton(router: router)
                    case .complete:
                        SignUpCompleteView(viewModel: router.signupViewModel)
                            .backButton(router: router)
                    }
                }
        }
    }

}
