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
            LazyVGrid(columns: [.init()], spacing: 0, content: {
                ForEach(datas, id:\.date) { data in
                    if data.schedules.isEmpty.not(),
                       let schedule = data.schedules.first {
                        let item = schedule.toCellData(isToday: data.isToday, viewType: .all)
                        Button(action: { viewModel.clickSessionDetail(id: schedule.id) }) {
                            YPScheduleCell(model: item, isLast: datas.last?.date == data.date)
                        }
                        .buttonStyle(.plain)
                    }
                }
            })
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    AllScheduleListView(
        datas: [],
        viewModel: .init()
    )
}
