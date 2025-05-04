//
//  ScheduleBoardView.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/19/25.
//

import SwiftUI

struct ScheduleBoardView: View {
    
    @State var viewModel: ScheduleBoardViewModel = .init()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            YPNavigationTitleView(text: "일정", font: .pretendard24(.bold))
                .padding(.horizontal, 20)
                .padding(.top, 12)
            
            YPSection(sections: viewModel.sections, isSelected: $viewModel.isSelected, tintColor: Color.yapp(.semantic(.label(.normal))))
            
            TabView(selection: $viewModel.isSelected) {
                AllScheduleView()
                    .tag(YPSectionType.all)
                    .padding(.top, 20)
                
                SessionScheduleView()
                    .tag(YPSectionType.session)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .transition(.slide)
            .ignoresSafeArea(edges: [.top, .bottom])
        }
    }
}

#Preview {
    ScheduleBoardView()
}
