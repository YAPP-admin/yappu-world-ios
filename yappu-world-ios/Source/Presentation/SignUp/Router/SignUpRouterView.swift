//
//  SignUpRootView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/12/25.
//


import SwiftUI

struct SignUpRouterView: View {
    @Bindable
    private var router: SignUpNavigationRouter
    
    init(router: SignUpNavigationRouter) {
        self.router = router
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            SignUpCodeView(viewModel: router.viewModel)
                .navigationDestination(for: SignUpNavigationRouter.Path.self) { path in
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
