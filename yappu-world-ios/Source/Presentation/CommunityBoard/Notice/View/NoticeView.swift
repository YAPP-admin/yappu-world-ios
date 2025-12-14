//
//  NoticeView.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import SwiftUI

struct NoticeView: View {
    
    @Bindable
    var viewModel: NoticeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                NoticeTypeSelector(selectedType: $viewModel.selectedNoticeList)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            List {
                if viewModel.notices.isEmpty {
                    empty
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ForEach(viewModel.notices, id: \.id) { notice in
                        let isLast = viewModel.notices.last?.id == notice.id
                        
                        Button(action: { viewModel.clickNoticeDetail(id: notice.id) }) {
                            NoticeCell(notice: notice, isLoading: viewModel.isLoading)
                                .contentShape(Rectangle())
                                .padding(.bottom, 10)
                                .overlay(alignment: .bottom) {
                                    YPDivider(color: .gray08)
                                }
                        }
                        .buttonStyle(.plain)
                        .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .listRowSeparator(.hidden)
                        .if(isLast && viewModel.hasNext) { $0.task {
                            await viewModel.loadMore()
                        }}
                        .id(notice.id)
                    }
                }
            }
            .listStyle(.plain)
            .listRowSpacing(10)
            .refreshable(action: viewModel.listRefreshable)
            .contentMargins(.vertical, 16)
        }
        .task(viewModel.listTask)
    }
}

// MARK: - Configure Views
private extension NoticeView {
    @ViewBuilder
    var empty: some View {
        Image("illust_member_home_disabled_notFound")
            .padding(.top, 150)
            .listRowSeparator(.hidden)
        
        Text("아직 작성된 공지사항이 없어요")
            .font(.pretendard14(.regular))
            .foregroundStyle(.yapp(.semantic(.label(.alternative))))
            .listRowSeparator(.hidden)
    }
}

#Preview {
    NoticeView(viewModel: .init())
}
