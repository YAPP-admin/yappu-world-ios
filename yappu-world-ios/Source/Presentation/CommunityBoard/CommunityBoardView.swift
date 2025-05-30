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
    
    var body: some View {
        
        VStack(alignment: .leading) {
            YPNavigationTitleView(text: "게시판", font: .pretendard24(.bold))
                .padding(.horizontal, 20)
                .padding(.top, 12)
            
            HStack {
                YPSection(sections: viewModel.communityBoardSections,
                          isSelected: $viewModel.isSelected)
            }
            
            TabView(selection: $viewModel.isSelected, content: {
                NoticeView(viewModel: noticeViewModel)
                    .tag(YPSectionType.notice)
                
                CommunityView()
                    .tag(YPSectionType.community)
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .transition(.slide)
            .padding(.top, 10)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    CommunityBoardView()
}
