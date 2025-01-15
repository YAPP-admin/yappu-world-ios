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
                .navigationDestination(for: LoginNavigationRouter.Path.self) { path in
                    switch path {
                    case let .code(viewModel):
                        SignUpCodeView(viewModel: viewModel)
                    case let .complete(viewModel):
                        SignUpCompleteView(viewModel: viewModel)
                    }
                }
        }
    }
}
