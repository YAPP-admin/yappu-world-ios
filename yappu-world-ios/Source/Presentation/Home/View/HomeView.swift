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
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                ActivitySessionSection(
                    scrollIndex: $scrollIndex,
                    sessionList: viewModel.activitySessions
                ) {
                    viewModel.clickAllSessionButton()
                }
                .padding(.top, 18)
                .opacity(Double((180 + scrollOffset) / 100))
                
                scheduleSection
            }
            .trackScrollMetrics(
                coordinateSpace: "HomeScrollView",
                offset: $scrollOffset,
                contentSize: .constant(0)
            )
        }
        .coordinateSpace(name: "HomeScrollView")
        .background { background }
        .refreshable { await viewModel.scrollViewRefreshable() }
        .yappBottomPopup(isOpen: $viewModel.isSheetOpen) {
            AttendanceAuthSheetView(viewModel: viewModel)
        }
        .onChange(of: viewModel.isSheetOpen) {
            if viewModel.isSheetOpen.not() { hideKeyboard() }
        }
        .task { await viewModel.onTask() }
    }
}

extension HomeView {
    private var background: some View {
        VStack {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 1, green: 0.68, blue: 0.19), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.98, green: 0.38, blue: 0.15), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0, y: 0.5),
                endPoint: UnitPoint(x: 1.06, y: 0.5)
            )
            .containerRelativeFrame(.vertical) { height, _ in
                return height / 3 * 2
            }
            .ignoresSafeArea()
            .opacity(Double((180 + scrollOffset) / 100))
            
            Color.yapp(.semantic(.background(.normal(.normal))))
        }
    }
    
    private var scheduleSection: some View {
        VStack(spacing: 40) {
            HomeAttendView(upcomingSession: viewModel.upcomingSession, upcomingState: viewModel.upcomingState, attendanceButtonAction: viewModel.clickSheetToggle)
            SessionAttendanceListView(title: "최근 출석 현황", titleFont: .pretendard18(.semibold), histories: viewModel.attendanceHistories, moreButtonAction: viewModel.clickAttendanceHistoryMoreButton)
        }
        .padding(.top, 24)
        .background(.yapp(.semantic(.background(.normal(.normal)))))
        .cornerRadius(radius: 12, corners: [.topLeft, .topRight])
    }
    
    private func memberBadge(member: Member) -> some View {
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
