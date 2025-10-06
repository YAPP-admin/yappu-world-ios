//
//  SessionDetailView.swift
//  yappu-world-ios
//
//  Created by 김건형 on 9/26/25.
//

import SwiftUI
import MarkdownUI

struct SessionDetailView: View {
    
    @State
    var viewModel: SessionDetailViewModel
    
    var body: some View {
        YPScrollView(axis: .vertical,
                     showsIndicators: true,
                     ignoreSafeArea: [],
                     content: {
            LazyVStack(alignment: viewModel.sessionEntity == nil ? .center : .leading, spacing: 24) {
                HStack { Spacer() }
                if let session = viewModel.sessionEntity {
                    sessionTopView(session: session)
                    
                    sessionBottomView(session: session)
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
            .padding(.bottom, 45)
        }) // YPScrollView
        .task { await viewModel.onTask() }
        .backButton(title: "세션 상세", action: viewModel.clickBackButton)
    }
}
//MARK: - SessionDetailView Extesions
extension SessionDetailView {
    func sessionTopView(session: SessionDetailEntity) -> some View {
        let phase = session.progressPhase
        
        return VStack(alignment: .leading, spacing: 16) {
            // Bedge
            Text(phase.title)
                .font(.pretendard13(.medium))
                .foregroundStyle(.common100)
                .frame(width: 43, height: 24)
                .padding(.vertical, 1.5)
                .padding(.horizontal, 3)
                .background(phase.color)
                .clipRectangle(8)
            
            // Title
            Text(session.title)
                .font(.pretendard28(.semibold))
                .foregroundStyle(.yapp(.semantic(.label(.normal))))
            
            // Info
            VStack(spacing: 8) {
                // 시간
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image(.history)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.accentCoolNatural)
                        .offset(y: 3) // 이미지 위치가 맞지 않음
                    
                    let startDate = "\(session.startDate.toDateFormat(as: "yyyy. MM. dd")) (\(session.startDayOfWeek))"
                    let startTimeData = "\(session.startTime)".toTimeFormat(as: "a hh시 mm분")
                    let endDate = "\(session.endDate.toDateFormat(as: "yyyy. MM. dd")) (\(session.endDayOfWeek))"
                    let endTimeData = "\(session.endTime)".toTimeFormat(as: "a hh시 mm분")
                    
                    // startDate와 endDate가 같을 경우
                    if session.startDate == session.endDate {
                        Text("\(startDate) / \(startTimeData) - \(endTimeData)")
                            .font(.pretendard14(.regular))
                    } else {
                        Text("\(startDate) \(startTimeData) - \(endDate) \(endTimeData)")
                            .font(.pretendard14(.regular))
                    }
                    
                    Spacer()
                } // HStack
                
                // 위치
                HStack(alignment: .top, spacing: 8) {
                    Image(.location)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.accentCoolNatural)
                        .offset(y: 3) // 이미지 위치가 맞지 않음
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.place ?? "")
                            .font(.pretendard14(.regular))
                            .foregroundStyle(.yapp(.semantic(.label(.normal))))
                        
                        Text(session.address ?? "")
                            .font(.pretendard12(.regular))
                            .foregroundStyle(.yapp(.semantic(.label(.assistive))))
                    } // VStack
                    
                    Spacer()
                } // HStack
                NaverMap(
                    latitude: session.latitude ?? 37.496486,
                    longitude: session.longitude ?? 127.028361
                )
                .cornerRadius(radius: 8, corners: .allCorners)
                .frame(height: 120)
                .padding(.leading, 24)
            } // VStack
        }
        .padding(.horizontal, 20)
    }
    
    func sessionBottomView(session: SessionDetailEntity) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            YPSection(sections: viewModel.sections, isSelected: $viewModel.isSelected, tintColor: Color.yapp(.semantic(.primary(.normal))))
            
            TabView(selection: $viewModel.isSelected) {
                Color.white
                    .tag(YPSectionType.timeTable)
                
                noticesListView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // 전체 영역 채우기
                    .tag(YPSectionType.notice)
                
                Color.white
                    .tag(YPSectionType.attend)
            }
            .frame(height: 500)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .transition(.slide)
            .ignoresSafeArea(edges: [.top, .bottom])
            
            Spacer()
        } // VStack
    }
    
    func noticesListView() -> some View {
        YPScrollView {
            LazyVStack(spacing: 9) {
                
                Spacer()
                    .padding(.top, 16)
                if let sessionEntity = viewModel.sessionEntity {
                    if sessionEntity.notices.isEmpty && viewModel.isSkeleton.not() {
                        Image("illust_member_home_disabled_notFound")
                            .padding(.top, 150)
                        Text("아직 작성된 공지사항이 없어요")
                            .font(.pretendard14(.regular))
                            .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                    } else {
                        ForEach(sessionEntity.notices, id: \.id) { notice in
                            NoticeCell(notice: .init(id: notice.id.uuidString, notice: notice.notice, writer: notice.writer), isLoading: viewModel.isSkeleton)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    // 공지사항 클릭
                                    viewModel.clickNoticeDetail(id: notice.id.uuidString)
                                }
                                .redacted(reason: viewModel.isSkeleton ? .placeholder : .invalidated)
                                .onAppear {
                                    //                                Task { try await viewModel.loadMore(appearId: notice.id) }
                                }
                            YPDivider(color: .gray08)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                        .padding(.bottom, 16)
                }
            } // LazyVStack
        } // YPScrollView
    }
}

#Preview {
    SessionDetailView(viewModel: .init(id: ""))
}
