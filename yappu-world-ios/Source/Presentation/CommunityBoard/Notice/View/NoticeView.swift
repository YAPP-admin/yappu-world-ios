//
//  NoticeView.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import SwiftUI

struct NoticeView: View {
    
    @State var viewModel: NoticeViewModel
    
    @State var firstAppear: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Group {
                HStack {
                    NoticeTypeSelector(selectedType: $viewModel.selectedNoticeList)
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            
            YPScrollView {
                
                LazyVStack(spacing: 9) {
                    
                    Spacer()
                        .padding(.top, 16)
                    
                    if viewModel.notices.isEmpty && viewModel.isSkeleton.not() {
                        Image("illust_member_home_disabled_notFound")
                            .padding(.top, 150)
                        Text("아직 작성된 공지사항이 없어요")
                            .font(.pretendard14(.regular))
                            .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                    } else {
                        ForEach(viewModel.notices, id: \.id) { notice in
                            NoticeCell(notice: notice, isLoading: viewModel.isSkeleton)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.clickNoticeDetail(id: notice.id)
                                }
                                .redacted(reason: viewModel.isSkeleton ? .placeholder : .invalidated)
                                .onAppear {
                                    Task { try await viewModel.loadMore(appearId: notice.id) }
                                    
                                }
                            YPDivider(color: .gray08)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                        .padding(.bottom, 16)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .refreshable { Task { try await viewModel.loadNotices(first: true) } }
        }
        .task {
            if firstAppear.not() {
                do {
                    firstAppear = true
                    try await viewModel.loadNotices(first: true)
                } catch {
                    await viewModel.errorAction()
                }
            }
            
        }
    }
}

#Preview {
    NoticeView(viewModel: .init())
}
