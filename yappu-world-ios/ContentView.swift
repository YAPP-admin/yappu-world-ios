//
//  ContentView.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/4/25.
//

import SwiftUI

import Dependencies

struct ContentView: View {
    @Dependency(FlowRouter.self)
    private var router
    
    @State
    private var currentFlow: Flow = .login
    
    var body: some View {
        navigationView
            .animation(.easeInOut(duration: 0.3), value: currentFlow)
            .task {
                for await flow in router.publisher() {
                    currentFlow = flow
                }
            }
            .onDisappear { router.cancelBag() }
    }
}

extension ContentView {
    @ViewBuilder
    var navigationView: some View {
        switch currentFlow {
        case .home:
            HomeNavigationView(router: HomeNavigationRouter())
        case .login:
            LoginNavigationView(router: LoginNavigationRouter())
        }
    }
}

#Preview {
    ContentView()
}
