//
//  NoticeView.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import SwiftUI

struct NoticeView: View {
    
    @State var viewModel: NoticeViewModel = .init()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Group {
                InformationLabel(title: "공지사항", titleFont: .pretendard24(.bold))
                NoticeTypeSelector(selectedType: $viewModel.selectedNoticeList)
            }
            .padding(.horizontal, 20)
            
            YPScrollView {
                
                LazyVStack(spacing: 9) {
                    
                    Spacer()
                        .padding(.top, 16)
                    
                    ForEach(viewModel.notices, id: \.id) { notice in
                        NoticeCell(notice: notice)
                        YPDivider(color: .gray08)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .padding(.bottom, 16)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    ZStack {
//        Color.red.opacity(0.2)
        NoticeView()
    }
    
}
