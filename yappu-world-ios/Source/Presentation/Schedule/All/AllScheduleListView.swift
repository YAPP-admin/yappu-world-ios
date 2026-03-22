//
//  ScheduleListView.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import SwiftUI

struct AllScheduleListView: View {
    var datas: [ScheduleDateEntity]
    var viewModel: AllScheduleViewModel

    var body: some View {
        YPScrollView {
            LazyVStack(spacing: 0) {
                ForEach(datas, id:\.date) { data in
                    ForEach(data.schedules) { schedule in
                        let item = schedule.toCellData(isToday: data.isToday, viewType: .all)
                        Button(action: { viewModel.clickSessionDetail(id: schedule.id) }) {
                            YPScheduleCell(model: item, isLast: datas.last?.date == data.date)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .refreshable(action: viewModel.onPageRefresh)
    }
}

#Preview {
    AllScheduleListView(
        datas: [],
        viewModel: .init()
    )
}
