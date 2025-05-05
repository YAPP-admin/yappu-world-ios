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

    var body: some View {
        
        VStack {
            HStack {
                Image("yapp_logo")
                Spacer()

                Button(action: {
                    viewModel.clickSetting()
                }, label: {
                    Image("setting_icon")
                })
            }
            .padding(.horizontal, 20)
            
            ScrollView {
                HomeAttendView(upcomingSession: viewModel.upcomingSession, attendanceButtonAction: viewModel.clickSheetToggle)
                
                SessionAttendanceListView(title: "최근 출석 현황", titleFont: .pretendard18(.semibold), histories: viewModel.attendanceHistories, moreButtonAction: viewModel.clickAttendanceHistoryMoreButton)
                    .padding(.top, 41)
                
            }
            .refreshable {
                do {
                    await MainActor.run {
                        viewModel.resetState()
                    }
                    
                    let _ = try await Task {
                        try await Task.sleep(for: .seconds(1))
                        try await viewModel.onTask()
                        return true
                    }.value
                } catch {
                    print("error", error.localizedDescription)
                }
            }
        }
        .background(Color.mainBackgroundNormal.ignoresSafeArea())
        .task {
            do {
                try await viewModel.onTask()
            } catch {
                print("error", error.localizedDescription)
            }
        }
        .yappBottomPopup(isOpen: $viewModel.isSheetOpen) {
            AttendanceAuthSheetView(viewModel: viewModel)
        }
        .onChange(of: viewModel.isSheetOpen) {
            if viewModel.isSheetOpen.not() { hideKeyboard() }
        }
    }
}

extension HomeView {

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
