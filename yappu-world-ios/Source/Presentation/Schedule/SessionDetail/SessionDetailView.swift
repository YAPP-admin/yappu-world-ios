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
                    SessionTopSection(session: session)
                    
                    // 하단 섹션 (탭/공지 리스트 등)
                    SessionBottomSection(
                        sections: viewModel.sections,
                        selection: $viewModel.isSelected,
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
        .backButton(title: "세션 상세", action: viewModel.clickBackButton)
    }
}
// MARK: - Top Section
/// 상단: 진행상태 뱃지/제목/시간/위치/지도
private struct SessionTopSection: View {
    let session: SessionDetailEntity

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

                // 시간
                InfoRow(icon: Image(.history)) {
                    Text(session.dateRangeText)
                        .font(.pretendard14(.regular))
                }

                // 위치
                if session.hasLocation {
                    InfoRow(icon: Image(.location), alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(session.place ?? "")
                                .font(.pretendard14(.regular))
                                .foregroundStyle(.yapp(.semantic(.label(.normal))))
                            Text(session.address ?? "")
                                .font(.pretendard12(.regular))
                                .foregroundStyle(.yapp(.semantic(.label(.assistive))))
                        }
                    }
                }

                // 지도
                NaverMap(
                    latitude: session.latitude ?? 37.496486,
                    longitude: session.longitude ?? 127.028361
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
    let sections: [YPSectionEntity]
    @Binding var selection: YPSectionType
    let notices: [SessionDetailEntity.NoticeEntity]
    let isSkeleton: Bool
    let onTapNotice: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            YPSection(
                sections: sections,
                isSelected: $selection,
                tintColor: Color.yapp(.semantic(.primary(.normal)))
            )

            // TabView는 뷰만 교체하고, 높이는 유연하게
            TabView(selection: $selection) {
                // 타입테이블 탭
                Color.white
                    .tag(YPSectionType.timeTable)

                // 공지사항 탭
                NoticesListView(
                    notices: notices,
                    isSkeleton: isSkeleton,
                    onTapNotice: onTapNotice
                )
                .tag(YPSectionType.notice)

                // 출석 탭
                Color.white
                    .tag(YPSectionType.attend)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .transition(.slide)
            .ignoresSafeArea(edges: [.top, .bottom])
            .frame(minHeight: 300) // TODO: 필요 시 동적으로 계산
        }
    }
}

// MARK: - Notices
private struct NoticesListView: View {
    let notices: [SessionDetailEntity.NoticeEntity]
    let isSkeleton: Bool
    let onTapNotice: (String) -> Void

    var body: some View {
        YPScrollView {
            LazyVStack(spacing: 9) {
                Spacer().padding(.top, 16)

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
                                id: notice.id.uuidString,
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
                    .padding(.horizontal, 20)
                }

                Spacer().padding(.bottom, 16)
            }
        }
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

// MARK: - Entity Display Extensions
/// 뷰에서의 포맷팅 책임을 최소화하기 위해, 표시용 문자열/상태를 Entity 확장으로 분리
private extension SessionDetailEntity {

    /// 날짜/시간 구간 표시 문자열
    var dateRangeText: String {
        let startDateText = "\(startDate.toDateFormat(as: "yyyy. MM. dd")) (\(startDayOfWeek))"
        let startTimeText = "\(startTime)".toTimeFormat(as: "a hh시 mm분")
        let endDateText   = "\(endDate.toDateFormat(as: "yyyy. MM. dd")) (\(endDayOfWeek))"
        let endTimeText   = "\(endTime)".toTimeFormat(as: "a hh시 mm분")

        // 동일 날짜면 날짜는 한 번만 표기
        if startDate == endDate {
            return "\(startDateText) / \(startTimeText) - \(endTimeText)"
        } else {
            return "\(startDateText) \(startTimeText) - \(endDateText) \(endTimeText)"
        }
    }

    /// 위치 유효성
    var hasLocation: Bool {
        (place?.isEmpty == false) || (address?.isEmpty == false) || (latitude != nil && longitude != nil)
    }
}


#Preview {
    NavigationStack {
        SessionDetailView(viewModel: .init(id: ""))
            .navigationBarTitleDisplayMode(.inline)
    }
}
