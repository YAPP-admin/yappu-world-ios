//
//  MyPageNavigationView.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import SwiftUI

struct MyPageNavigationView: View {
    @Bindable
    private var router: MyPageNavigationRouter
    
    init(router: MyPageNavigationRouter) {
        self.router = router
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            MyPageView(viewModel: router.myPageViewModel)
                .navigationDestination(for: MyPagePath.self) { path in
                    switch path {
                    case .setting:
                        if let viewModel = router.settingViewModel {
                            SettingView(viewModel: viewModel)
                        }
                    case .attendances:
                        EmptyView() // 임시
                    case .preActivities:
                        if let viewModel = router.preActivitesViewModel {
                            PreActivitiesView(viewModel: viewModel)
                        }
                    case let .safari(url):
                        YPSafariView<HomePath>(url: url)
                            .ignoresSafeArea()
                            .navigationBarBackButtonHidden()
                    }
                }
        }
        .task {
            await router.onTask()
        }
    }
}

#Preview {
    HomeNavigationView(router: .init())
}
