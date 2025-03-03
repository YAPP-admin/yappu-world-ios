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
                
                if let role = viewModel.currentUserRole, role == .Admin {
                    DisplayTargetBadgeView(target: viewModel.notice.displayTarget)
                }
                
                noticeTitleView
                
                NoticeBadge(notice: viewModel.notice)
                
                content
                    .padding(.top, 15)
                
                if let role = viewModel.currentUserRole, role == .Admin {
                    YPDivider(color: .yapp(.semantic(.line(.normal))))
                        .padding(.vertical, 24)
                    
                    noticeProgressView
                }
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
    
    var noticeProgressView: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.yapp(.semantic(.fill(.alternative))))
            
            HStack {
                Text("공지 전달률")
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))
                    .font(.pretendard16(.semibold))
                
                Text("\(viewModel.readPercent())%")
                    .font(.pretendard16(.semibold))
                    .foregroundStyle(.yapp(.semantic(.primary(.normal))))
                Spacer()
                
                if let readCount = viewModel.notice.readCount,
                   let totalCount = viewModel.notice.totalMembers {
                    Text("\(readCount)/\(totalCount)명")
                        .font(.pretendard11(.medium))
                        .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                }
                
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    NoticeDetailView(viewModel: .init(id: ""))
}
