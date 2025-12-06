//
//  HomeView.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/6/25.
//

import SwiftUI

struct HomeView: View {
    @State
    var viewModel: HomeViewModel
    @State
    private var scrollIndex: Int?
    @State
    private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            logo
            
            YPScrollView(showsIndicators: false) {
                content
                    .padding(.horizontal, 20)
            }
            .setSafeAreaInsets([.top])
            .coordinateSpace(name: "HomeScrollView")
            .refreshable { await viewModel.scrollViewRefreshable() }
            .tint(.yapp(.semantic(.primary(.normal))))
            .contentMargins(
                .top,
                EdgeInsets(top: 56, leading: 0, bottom: 0, trailing: 0),
                for: .scrollContent
            )
        }
        .background(.yapp(.semantic(.background(.normal(.alternative)))))
        .animation(.bouncy, value: viewModel.upcomingSession)
        .onChange(of: viewModel.isSheetOpen) {
            if viewModel.isSheetOpen.not() { hideKeyboard() }
        }
        .task { await viewModel.onTask() }
    }
}

private extension HomeView {
    var logo: some View {
        Image(.yappLogo)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 81, height: 24, alignment: .leading)
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(scrollOffset / 56)
    }
    
    var content: some View {
        VStack(spacing: 16) {
            sessionSection
            
            checkItOutButtonSection
            
            firstYAPPSection
        }
        .trackScrollMetrics(
            coordinateSpace: "HomeScrollView",
            offset: $scrollOffset,
            contentSize: .constant(0)
        )
    }
    
    var sessionSection: some View {
        VStack(spacing: 24) {
            todaySessionSection
            
            if let session = viewModel.upcomingSession,
               session.notices.isEmpty.not() {
                YPDivider(color: .yapp(.semantic(.line(.normal))))
                
                sessionNoticeSection(session)
            }
        }
        .padding(16)
        .background(.yapp(.semantic(.background(.normal(.normal)))))
        .clipRectangle(16)
    }
    
    var attendanceSection: some View {
        VStack(spacing: 8) {
            noticeBanner
                .setYPSkeletion(isLoading: viewModel.isLoading)

            if viewModel.upcomingState != .NOSESSION {
                attendanceButton
            }
        }
    }
    
    var todaySessionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Text("오늘의 세션")
                    .font(.pretendard14(.bold))
                    .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                
                todaySessionPhaseChip
                    .setYPSkeletion(isLoading: viewModel.isLoading)
                
                Spacer()
                
                // 오늘의 세션이 없음일 때, 상세보기 글자를 미노출
                if viewModel.upcomingSession != nil {
                    Button("상세보기") {
                        viewModel.sessionDetailButtonAction()
                    }
                    .font(.pretendard14(.bold))
                    .foregroundStyle(.yapp(.semantic(.primary(.normal))))
                    .setYPSkeletion(isLoading: viewModel.isLoading)
                }
            }
            
            todaySessionLabel
            
            attendanceSection
        }
    }
    
    @ViewBuilder
    var todaySessionPhaseChip: some View {
        switch viewModel.todayProgressPhase {
        case .done:
            YPChip("종료")
                .color(.neutral)
        case .ongoing:
            YPChip("진행중")
        case .today:
            YPChip("당일")
                .style(.weak)
                .color(.yellow)
        case .pending:
            YPChip("예정")
                .style(.weak)
                .color(.yellow)
        default:
            YPChip("없음")
                .color(.yellow)
        }
    }
    
    @ViewBuilder
    var todaySessionLabel: some View {
        if let session = viewModel.upcomingSession {
            VStack(alignment: .leading, spacing: 8) {
                Text(session.name)
                    .font(.pretendard22(.bold))
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))
                    .setYPSkeletion(isLoading: viewModel.isLoading)

                HStack(spacing: 4) {
                    Image(.location)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.yapp(.semantic(.interaction(.inactive))))
                        .frame(width: 16, height: 16)

                    Text(session.place ?? "-")
                        .font(.pretendard14(.regular))
                        .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                        .setYPSkeletion(isLoading: viewModel.isLoading)
                }

                HStack(spacing: 4) {
                    Image(.history)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.yapp(.semantic(.interaction(.inactive))))
                        .frame(width: 16, height: 16)

                    Text(viewModel.todaySessionTime ?? "-")
                        .font(.pretendard14(.regular))
                        .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                        .setYPSkeletion(isLoading: viewModel.isLoading)
                }
            }
        } else {
            Text("오늘은 \(Date().toString(.monthDay))이에요")
                .font(.pretendard22(.bold))
                .foregroundStyle(.yapp(.semantic(.label(.normal))))
                .setYPSkeletion(isLoading: viewModel.isLoading)
        }
    }

    @ViewBuilder
    var noticeBanner: some View {
        let imageResource: ImageResource = {
            switch viewModel.upcomingState {
            case .INACTIVE_DAY,
                 .AVAILABLE,
                 .ATTENDED,
                 .LATE,
                 .EARLY_LEAVE,
                 .EXCUSED:
                return .clapHands
            case .INACTIVE_YET, .ABSENT:
                return .waveHands
            case .NOSESSION:
                return .snooze
            }
        }()

        if let banner = viewModel.upcomingState.banner {
            HStack(spacing: 4) {
                Image(imageResource)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                
                Text(banner)
                    .font(.pretendard12(.medium))
                    .foregroundStyle(.labelGray)
            }
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(Color.activityCellBackgroundColor)
            .cornerRadius(10)
        }
    }

    @ViewBuilder
    var attendanceButton: some View {
        let buttonStyle: YPButtonStyle = {
            switch viewModel.upcomingState {
            case .ATTENDED, .LATE, .EARLY_LEAVE, .EXCUSED:
                // ONGOING 상태인지 확인 (시작일이 지난 경우)
                if viewModel.upcomingSession?.progressPhase == "ONGOING" {
                    return .yapp(radius: 12, style: .custom(
                        fg: .yapp(.primitive(.orange80)),
                        bg: .yapp(.primitive(.orange99))
                    ))
                } else {
                    return .yapp(radius: 12, style: .custom(
                        fg: .yapp(.semantic(.primary(.normal))),
                        bg: .yapp(.primitive(.orange95))
                    ))
                }
            case .AVAILABLE:
                return .yapp(radius: 8, style: .primary)
            default:
                return .yapp(radius: 8, style: .custom(
                    fg: .yapp(.semantic(.label(.disable))),
                    bg: .yapp(.semantic(.background(.normal(.alternative))))
                ))
            }
        }()

        Button(action: viewModel.clickSheetToggle) {
            Text(viewModel.upcomingState.button)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(buttonStyle)
        .setYPSkeletion(isLoading: viewModel.isLoading)
        .disabled(viewModel.upcomingState.isDisabled)
    }
    
    func sessionNoticeSection(_ session: UpcomingSession) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("세션 공지")
                .font(.pretendard13(.bold))
                .foregroundStyle(.yapp(.semantic(.label(.alternative))))

            sessionNoticeList(session)
        }
    }

    func sessionNoticeList(_ session: UpcomingSession) -> some View {
        VStack(spacing: 0) {
            ForEach(session.notices) { notice in
                let isLast = notice.id == session.notices.last?.id

                sessionNoticeCell(notice)
                    .if(!isLast) { $0.overlay(alignment: .bottom) {
                        YPDivider(color: .yapp(.semantic(.line(.alternative))))
                    }}
            }
        }
    }

    func sessionNoticeCell(_ notice: UpcomingSession.Notice) -> some View {
        Button(action: { viewModel.sessionNoticeCellButtonAction(id: notice.id) }) {
            HStack {
                Text(notice.title)
                    .font(.pretendard16(.regular))
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))
                    .setYPSkeletion(isLoading: viewModel.isLoading)

                Spacer()

                Image(.chevronRight)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.yapp(.semantic(.label(.disable))))
                    .frame(width: 16, height: 16, alignment: .trailing)
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
    }
    
    var checkItOutButtonSection: some View {
        HStack(spacing: 16) {
            attendanceScoreButton
            
            allSessionButton
        }
    }
    
    var attendanceScoreButton: some View {
        Button(action: viewModel.attendanceScoreButtonAction) {
            checkItOutButtonLabel("출석 점수")
                .padding(16)
                .background(alignment: .bottomTrailing) {
                    Image(.detectiveOwl)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .trailing)
                        .padding(.trailing, -32)
                        .padding(.bottom, -28)
                }
                .background(.yapp(.semantic(.background(.normal(.normal)))))
                .clipRectangle(16)
        }
    }
    
    var allSessionButton: some View {
        Button(action: viewModel.allSessionButtonAction) {
            checkItOutButtonLabel("전체 세션")
                .padding(16)
                .background(alignment: .bottomTrailing) {
                    Image(.coffeeOwl)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 184, height: 157, alignment: .trailing)
                        .padding(.trailing, -66)
                        .padding(.bottom, -80)
                }
                .background(.yapp(.semantic(.background(.normal(.normal)))))
                .clipRectangle(16)
        }
    }
    
    func checkItOutButtonLabel(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.pretendard16(.bold))
                .foregroundStyle(.yapp(.semantic(.label(.normal))))
                .frame(height: 24)
            
            Text("확인하러가기")
                .font(.pretendard12(.regular))
                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                .frame(height: 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var firstYAPPSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("혹시.. 처음이YAPP?")
                .font(.pretendard18(.bold))
                .foregroundStyle(.yapp(.semantic(.label(.normal))))
            
            VStack(spacing: 0) {
                firstYAPPCell("YAPP 기본 규칙", action: { viewModel.clickBaseRule() })
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(.yapp(.semantic(.background(.normal(.normal)))))
            .clipRectangle(16)
        }
    }
    
    func firstYAPPCell(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(.winkYappu)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.pretendard16(.regular))
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))
                
                Spacer()
                
                Image(.chevronRight)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.yapp(.semantic(.label(.disable))))
                    .frame(width: 16, height: 16, alignment: .trailing)
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
    }

    func memberBadge(member: Member) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(member.color.opacity(0.10))

            Text(member.description)
                .font(.pretendard11(.medium))
                .foregroundStyle(member.color)
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
        }
        .fixedSize()
        .padding(.vertical, 9)
    }
}

#Preview {
    HomeView(viewModel: .init())
}
