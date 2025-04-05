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
                .navigationDestination(for: LoginPath.self) { path in
                    switch path {
                    case .name:
                        if let viewModel = router.signUpNameViewModel {
                            SignUpNameView(viewModel: viewModel)
                        }
                    case .email:
                        if let viewModel = router.signUpEmailViewModel {
                            SignUpEmailView(viewModel: viewModel)
                        }
                    case .password:
                        if let viewModel = router.signUpPasswordViewModel {
                            SignUpPasswordView(viewModel: viewModel)
                        }
                    case .history:
                        if let viewModel = router.signUpHistoryViewModel {
                            SignUpHistoryView(viewModel: viewModel)
                        }
                    case .complete:
                        if let viewModel = router.signUpCompleteViewModel {
                            SignUpCompleteView(viewModel: viewModel)
                        }
                    case let .safari(url):
                        YPSafariView<LoginPath>(url: url)
                            .ignoresSafeArea()
                            .navigationBarBackButtonHidden()
                    }
                }
        }
        .task {
            await router.onAppear()
        }
    }
}

#Preview {
    LoginNavigationView(router: LoginNavigationRouter())
}
