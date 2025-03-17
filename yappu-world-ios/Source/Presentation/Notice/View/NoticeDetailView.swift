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
        YPScrollView(axis: .vertical,
                     showsIndicators: true,
                     ignoreSafeArea: [],
                     content: {
            VStack(alignment: .leading, spacing: 9) {
                noticeTitleView
                
                NoticeBadge(notice: viewModel.noticeEntity)
                
                content
                    .padding(.top, 15)
            }
            .padding(.top, 16)
            .padding(.bottom, 45)
            .padding(.horizontal, 20)
        })
        .backButton(title: "공지사항", action: viewModel.clickBackButton)
        .onAppear(perform: viewModel.onAppear)
    }
    
}


extension NoticeDetailView {
    var noticeTitleView: some View {
        VStack {
            Text(viewModel.noticeEntity.notice.title)
                .font(.pretendard18(.semibold))
                .foregroundStyle(Color.labelGray)
            
        }
    }
    
    var content: some View {
        Text(viewModel.noticeEntity.notice.content)
            .font(.pretendard15(.regular))
            .foregroundStyle(.labelGray)
    }
}

#Preview {
    NoticeDetailView(viewModel: .init(id: ""))
}
