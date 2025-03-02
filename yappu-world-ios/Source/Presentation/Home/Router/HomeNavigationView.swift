//
//  HomeNavigationView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/19/25.
//

import SwiftUI

struct HomeNavigationView: View {
    @Bindable
    private var router: HomeNavigationRouter
    
    init(router: HomeNavigationRouter) {
        self.router = router
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            if let homeViewModel = router.homeViewModel {
                HomeView(viewModel: homeViewModel)
                    .navigationDestination(for: HomePath.self) { path in
                        switch path {
                        case .setting:
                            if let viewModel = router.settingViewModel {
                                SettingView(viewModel: viewModel)
                            }
                        case .noticeList:
                            if let viewModel = router.noticeViewModel {
                                NoticeView(viewModel: viewModel)
                            }
                        case .noticeDetail:
                            NoticeDetailView()
                        }
                    }
            }
        }
        .task {
            await router.onAppear()
        }
    }
}

#Preview {
    HomeNavigationView(router: .init())
}
