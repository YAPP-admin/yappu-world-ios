//
//  YPTabView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 4/18/25.
//

import SwiftUI

struct YPTabView: View {
    @Namespace
    private var tabSelected
    
    @State
    private var selectedTab: TabItem = .home
    
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
    }
}

private extension YPTabView {
    enum TabItem: CaseIterable {
        case home
        case schedule
        case notice
        case myPage
        
        var title: String {
            switch self {
            case .home: return "홈"
            case .schedule: return "일정"
            case .notice: return "게시판"
            case .myPage: return "설정"
            }
        }
        
        func image(_ isSelected: Bool) -> ImageResource {
            switch self {
            case .home:
                return isSelected ? .homeFill : .home
            case .schedule: return .calendar
            case .notice: return .listCategory
            case .myPage: return .myPage
            }
        }
    }
    
    @ViewBuilder
    func tabItem(_ tab: TabItem) -> some View {
        let isSelected = selectedTab == tab
        let color: Color = isSelected
        ? .yapp(.semantic(.primary(.normal)))
        : .yapp(.semantic(.label(.assistive)))
        
        Button {
            withAnimation(.bouncy) {
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
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.orange99)
                        .frame(width: 64)
                        .matchedGeometryEffect(id: "Tab_Selected", in: tabSelected)
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

#Preview {
    YPTabView()
}
