//
//  NoticeDetailView.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/23/25.
//

import SwiftUI

struct NoticeDetailView: View {
    
    @State
    var viewModel: NoticeDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Group {
                noticeTitleView
                    .padding(.top, 16)
                NoticeBadge(notice: viewModel.notice)
                
            }
            .padding(.horizontal, 20)
            
            YPScrollView(axis: .vertical, showsIndicators: true, content: {
                content
                    .padding(.horizontal, 20)
            })
            .ignoresSafeArea(edges: .bottom)
        }
        
    }
    

}


extension NoticeDetailView {
    var noticeTitleView: some View {
        VStack {
            Text(viewModel.notice.title)
                .font(.pretendard18(.semibold))
                .foregroundStyle(Color.labelGray)
            
        }
    }
    
    var content: some View {
        Text(viewModel.notice.content)
            .font(.pretendard15(.regular))
            .foregroundStyle(.labelGray)
    }
}

#Preview {
    NoticeDetailView(viewModel: .init(id: ""))
}
