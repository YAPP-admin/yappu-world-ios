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
            VStack {
                if let item = viewModel.statistic {
                    AttendanceStatusView(item: item)
                }
                
                YPDivider(height: 12)
                
                if let item = viewModel.statistic {
                    SessionStatusView(item: item)
                }
                
                SessionAttendanceListView(histories: viewModel.histories)
                    .setYPSkeletion(isLoading: viewModel.isInit)
            }
        }
        .backButton(title: "출석 내역", useBackButton: true, action: viewModel.backButton)
        .task { await viewModel.onTask() }
    }
}

#Preview {
    AttendanceListView(viewModel: .init())
}
