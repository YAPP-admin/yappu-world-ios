//
//  NoticeDetailView.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/23/25.
//

import SwiftUI
import MarkdownUI

struct NoticeDetailView: View {
    
    @State
    var viewModel: NoticeDetailViewModel
    
    var body: some View {
        YPScrollView(axis: .vertical,
                     showsIndicators: true,
                     ignoreSafeArea: [],
                     content: {
            VStack(alignment: viewModel.noticeEntity == nil ? .center : .leading, spacing: 9) {
                if let notice = viewModel.noticeEntity {
                    noticeTitleView(notice: notice)
                    NoticeBadge(notice: notice, isLoading: viewModel.isLoading)
                    content(notice: notice)
                        .padding(.top, 15)
                } else {
                    InformationLabel(title: "앗! 오류가 발생했어요", titleFont: .pretendard24(.bold))
                    Image("errorYappu")
                        .padding(.top, 200)
                    Text("예상하지 못한 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.")
                        .multilineTextAlignment(.center)
                        .font(.pretendard14(.regular))
                        .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                        .padding(.top, 23)
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 45)
            .padding(.horizontal, 20)
        })
        .backButton(title: "공지사항", action: viewModel.clickBackButton)
        .task {
            do {
                try await viewModel.onTask()
            } catch {
                await viewModel.errorAction()
            }
        }
    }
    
}


extension NoticeDetailView {
    func noticeTitleView(notice: NoticeEntity) -> some View {
        VStack {
            Text(notice.notice.title)
                .font(.pretendard18(.semibold))
                .foregroundStyle(Color.labelGray)
            
        }
    }
    
    func content(notice: NoticeEntity) -> some View {
        Markdown {
            notice.notice.content
        }
        .font(.pretendard15(.regular))
        .foregroundStyle(.labelGray)
    }
}

#Preview {
    NoticeDetailView(viewModel: .init(id: ""))
}
