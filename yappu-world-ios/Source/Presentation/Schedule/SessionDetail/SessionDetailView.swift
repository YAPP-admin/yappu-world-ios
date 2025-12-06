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
            if let session = viewModel.sessionEntity {
                // 정상 플로우: 상단/하단을 분리
                LazyVStack(alignment: viewModel.sessionEntity == nil ? .center : .leading, spacing: 24) {
                    // 상단 섹션 (뱃지/제목/시간/위치/지도)
                    SessionTopSection(
                        session: session,
                        onTapMapItem: { item in viewModel.clickMapItem(item: item) }
                    )
                    
                    // Divider
                    Color.gray08
                        .frame(height: 12)
                    
                    // 하단 섹션 (탭/공지 리스트 등)
                    SessionBottomSection(
                        notices: session.notices,
                        isSkeleton: viewModel.isSkeleton,
                        onTapNotice: { id in viewModel.clickNoticeDetail(id: id) }
                    )
                } // LazyVStack
                .padding(.bottom, 45)
            } else {
                // 에러 상태를 별도 뷰로 위임
                ErrorStateView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, 45)
            }
        }) // YPScrollView
        .task { await viewModel.onTask() }
        .toast(isPresented: $viewModel.showCopiedToast, text: "주소 복사가 완료됐어요!")
        .backButton(title: "세션 상세", action: viewModel.clickBackButton)
    }
}
// MARK: - Top Section
/// 상단: 진행상태 뱃지/제목/시간/위치/지도
struct SessionTopSection: View {
    let session: SessionDetailEntity
    let onTapMapItem: (ActionItem) -> Void

    enum ActionItem: CaseIterable, Identifiable {
        case kakao_map
        case naver_map
        case copy_location

        var id: Self { self }
        
        var image: ImageResource {
            switch self {
            case .kakao_map: return .kakaoMap
            case .naver_map: return .naverMap
            case .copy_location: return .copyLocation
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Badge
            Badge(phase: session.progressPhase)

            // Title
            Text(session.title)
                .font(.pretendard28(.semibold))
                .foregroundStyle(.yapp(.semantic(.label(.normal))))

            // Info
            VStack(spacing: 8) {

                // 날짜
                InfoRow(icon: Image(.calendar)) {
                    Text(session.isSameDate ? session.startDate : "\(session.startDate) ~ \(session.endDate)")
                        .font(.pretendard14(.regular))
                }
                
                // 시간
                InfoRow(icon: Image(.history)) {
                    Text("\(session.startTime) - \(session.endTime)")
                        .font(.pretendard14(.regular))
                }

                // 위치
                InfoRow(icon: Image(.location), alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.place)
                            .font(.pretendard14(.regular))
                            .foregroundStyle(.yapp(.semantic(.label(.normal))))
                        if let address = session.address {
                            Text(address)
                                .font(.pretendard12(.regular))
                                .foregroundStyle(.yapp(.semantic(.label(.assistive))))
                        }
                    }
                }
                
                HStack(spacing: 16) {
                    ForEach(ActionItem.allCases, id: \.self) { item in
                        Button {
                            onTapMapItem(item)
                        } label: {
                            Image(item.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.leading, 24)

                // 지도
                NaverMap(
                    latitude: session.latitude,
                    longitude: session.longitude
                )
                .cornerRadius(radius: 8, corners: .allCorners)
                .frame(height: 120)
                .padding(.leading, 24)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Bottom Section
/// 하단: 섹션 탭 + 탭 콘텐츠
private struct SessionBottomSection: View {
    let notices: [NoticeEntity]
    let isSkeleton: Bool
    let onTapNotice: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("공지사항")
                .font(.pretendard20(.semibold))
                .foregroundStyle(.yapp(.semantic(.label(.normal))))

            // 공지사항 탭
            NoticesListView(
                notices: notices,
                isSkeleton: isSkeleton,
                onTapNotice: onTapNotice
            )
        } // VStack
        .padding(.horizontal, 20)
    }
}

// MARK: - Notices
private struct NoticesListView: View {
    let notices: [NoticeEntity]
    let isSkeleton: Bool
    let onTapNotice: (String) -> Void
    
    var body: some View {
        LazyVStack(spacing: 9) {
            if notices.isEmpty && !isSkeleton {
                // 빈 상태
                VStack(spacing: 12) {
                    Image("illust_member_home_disabled_notFound")
                        .padding(.top, 150)
                    Text("아직 작성된 공지사항이 없어요")
                        .font(.pretendard14(.regular))
                        .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                }
            } else {
                // 리스트
                ForEach(notices, id: \.id) { notice in
                    NoticeCell(
                        notice: .init(
                            notice: notice.notice,
                            writer: notice.writer
                        ),
                        isLoading: false
                    )
                    .contentShape(Rectangle())
                    .onTapGesture { onTapNotice(notice.notice.id) }
                    //                        .redacted(reason: isSkeleton ? .placeholder : .invalidated)
                    
                    YPDivider(color: .gray08)
                }
            }
        } // LazyVStack
    }
}
// MARK: - Error
private struct ErrorStateView: View {
    
    var body: some View {
        VStack(spacing: 16) {
            HStack { Spacer() }
            HStack{
                InformationLabel(
                    title: "앗! 오류가 발생했어요",
                    titleFont: .pretendard24(.bold)
                )
                .padding(20)
                
                Spacer()
            } // HStack
            
            Image("errorYappu")
                .padding(.top, 200)
            
            Text("예상하지 못한 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.")
                .multilineTextAlignment(.center)
                .font(.pretendard14(.regular))
                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                .padding(.top, 23)
        }
        .frame(maxWidth: .infinity)
    }
}
// MARK: - Small Components
/// 진행 상태 뱃지
private struct Badge: View {
    let phase: ScheduleEntity.ProgressPhase
    
    var body: some View {
        Text(phase.title)
            .font(.pretendard13(.medium))
            .foregroundStyle(.common100)
            .frame(width: 43, height: 24)
            .padding(.vertical, 1.5)
            .padding(.horizontal, 3)
            .background(phase.color)
            .clipRectangle(8)
    }
}
/// 아이콘 + 컨텐츠 행
private struct InfoRow<Content: View>: View {
    let icon: Image
    var alignment: VerticalAlignment = .firstTextBaseline
    @ViewBuilder var content: () -> Content

    var body: some View {
        HStack(alignment: alignment, spacing: 8) {
            icon
                .infoIconStyle() // 공통 스타일
            
            content()
            
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        SessionDetailView(viewModel: .init(id: ""))
            .navigationBarTitleDisplayMode(.inline)
    }
}
