//
//  AttendanceListView.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import SwiftUI

struct AttendanceListView: View {
    
    @State var viewModel: AttendanceListViewModel
    
    init(viewModel: AttendanceListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if viewModel.isNotActive.not() {
                    if let item = viewModel.statistic {
                        AttendanceTopSectionView(item: item, sessionList: viewModel.histories)
                    }
                    
                    YPDivider(color: Color(hex: "#70737C").opacity(0.08), height: 12)
                    
                    SessionAttendanceListView(histories: viewModel.histories)
                        .setYPSkeletion(isLoading: viewModel.isInit)
                    
                    BylawsView(items: BylawItem.attendanceBylaws)
                } else {
                    Image("illust_member_home_disabled_notFound")
                        .padding(.top, 200)
                    
                    Text("활동 중인 회원만 출석 내역을 볼 수 있어요")
                        .font(.pretendard13(.regular))
                        .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                        .padding(.vertical, 12)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .backButton(title: "출석 내역", useBackButton: true, action: viewModel.backButton)
        .task { await viewModel.onTask() }
    }
}

#Preview {
    AttendanceListView(viewModel: .init(dummy: true))
}
