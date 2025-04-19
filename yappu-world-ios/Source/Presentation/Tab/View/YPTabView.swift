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
    private var router
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                HomeNavigationView(router: HomeNavigationRouter())
                    .toolbarBackground(.hidden, for: .tabBar)
                    .tag(TabItem.home)
                
                Color.white
                    .toolbarBackground(.hidden, for: .tabBar)
                    .tag(TabItem.schedule)
                
                NoticeView(viewModel: NoticeViewModel())
                    .toolbarBackground(.hidden, for: .tabBar)
                    .tag(TabItem.notice)
                
                SettingView(viewModel: SettingViewModel())
                    .toolbarBackground(.hidden, for: .tabBar)
                    .tag(TabItem.myPage)
            }
            
            tabBar
        }
        .task(onTask)
        .onDisappear { router.cancelBag() }
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
        for await item in router.publisher() {
            withAnimation(.spring(bounce: 0.3)) {
                selectedTab = item
            }
        }
    }
}

#Preview {
    YPTabView()
}
