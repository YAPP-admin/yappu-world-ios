//
//  CommunityBoardView.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/14/25.
//

import SwiftUI

struct CommunityBoardView: View {

    @State
    var viewModel: CommunityBoardViewModel = .init()

    @State
    var noticeViewModel: NoticeViewModel = .init()

    /// PastServiceListView VM은 TabViewNavigationRouter 소유 — 시트 팝업을 YPTabView 최상위에서 띄우기 위해 외부 주입
    let pastServiceListViewModel: PastServiceListViewModel

    var body: some View {

        VStack(alignment: .leading) {
            YPNavigationTitleView(text: "게시판", font: .pretendard24(.bold))
                .padding(.horizontal, 20)
                .padding(.top, 12)

            YPSection(
                sections: viewModel.communityBoardSections,
                isSelected: $viewModel.isSelected
            )

            TabView(selection: $viewModel.isSelected, content: {
                NoticeView(viewModel: noticeViewModel)
                    .tag(YPSectionType.notice)

                CommunityView()
                    .tag(YPSectionType.community)

                PastServiceListView(viewModel: pastServiceListViewModel)
                    .tag(YPSectionType.pastService)
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.top, 10)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    CommunityBoardView(pastServiceListViewModel: .init())
}
