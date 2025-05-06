//
//  YPTabView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 4/18/25.
//

import SwiftUI

import Dependencies

struct YPTabView: View {
    @Namespace
    private var tabSelected
    
    @State
    private var selectedTab: TabItem = .home
    
    @Dependency(Router<TabItem>.self)
    private var tabRouter
    
    @State
    private var router: TabViewNavigationRouter = .init()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(spacing: 0) {
                TabView(selection: $selectedTab) {
                    HomeView(viewModel: router.homeViewModel)
                        .toolbarBackground(.hidden, for: .tabBar)
                        .tag(TabItem.home)
                    
                    ScheduleBoardView()
                        .toolbarBackground(.hidden, for: .tabBar)
                        .tag(TabItem.schedule)
                    
                    CommunityBoardView()
                        .toolbarBackground(.hidden, for: .tabBar)
                        .tag(TabItem.notice)
                     
                    MyPageView(viewModel: router.myPageViewModel)
                        .toolbarBackground(.hidden, for: .tabBar)
                        .tag(TabItem.myPage)
                }
                
                tabBar
            }
            .navigationDestination(for: TabViewGlobalPath.self) { path in
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
                    if let viewModel = router.noticeDetailViewModel {
                        NoticeDetailView(viewModel: viewModel)
                    }
                case let .safari(url):
                    YPSafariView<TabViewGlobalPath>(url: url)
                        .ignoresSafeArea()
                        .navigationBarBackButtonHidden()
                case .attendances:
                    if let viewModel = router.attendanceListViewModel {
                        AttendanceListView(viewModel: viewModel)
                    }
                case .preActivities:
                    if let viewModel = router.preActivitesViewModel {
                        PreActivitiesView(viewModel: viewModel)
                    }
                }
            }
        }
        .task { await router.onTask() }
        .task { await onTask() }
        .onDisappear { tabRouter.cancelBag() }
        .yappDefaultPopup(isOpen: Binding(get: {
            YPGlobalPopupManager.shared.isPresented
        }, set: {
            YPGlobalPopupManager.shared.isPresented = $0
        }),
                          horizontalPadding: 0,
                          verticalPadding: 0,
                          showBackground: true,
                          view: {
            if let currentPopup = YPGlobalPopupManager.shared.currentPopup {
                YPAlertView(isPresented: Binding(get: {
                    YPGlobalPopupManager.shared.isPresented
                }, set: {
                    YPGlobalPopupManager.shared.isPresented = $0
                }),
                            title: currentPopup.title,
                            message: currentPopup.message,
                            confirmTitle: currentPopup.confirmTitle,
                            cancelTitle: currentPopup.cancelTitle ?? "아니요!",
                            buttonAxis: currentPopup.buttonAxis,
                            action: {
                    YPGlobalPopupManager.shared.dismiss()
                    router.clickPopupConfirm()
                })
            }
        })
        
    }
}

// MARK: - Configure Views
private extension YPTabView {
    @ViewBuilder
    func tabItem(_ tab: TabItem) -> some View {
        let isSelected = selectedTab == tab
        let color: Color = isSelected
        ? .yapp(.semantic(.primary(.normal)))
        : .yapp(.semantic(.label(.assistive)))
        
        Button {
            UISelectionFeedbackGenerator().selectionChanged()
            withAnimation(.spring(bounce: 0.3)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 8) {
                Image(tab.image(isSelected))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(color)
                
                Text(tab.title)
                    .font(.pretendard11(.semibold))
                    .foregroundStyle(color)
            }
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background {
                if isSelected {
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                    .fill(.orange99)
                    .frame(width: 64)
                    .matchedGeometryEffect(
                        id: "Tab_Selected",
                        in: tabSelected
                    )
                }
            }
        }
    }
    
    var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.hashValue) { tab in
                tabItem(tab)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(.yapp(.semantic(.background(.elevated(.normal)))))
        .overlay(alignment: .top) {
            YPDivider(color: Color(hex: "#F5F5F5"))
                .frame(height: 1)
        }
    }
}

// MARK: - Functions
private extension YPTabView {
    @Sendable
    func onTask() async {
        for await item in tabRouter.publisher() {
            withAnimation(.spring(bounce: 0.3)) {
                selectedTab = item
            }
        }
    }
}

#Preview {
    YPTabView()
}
