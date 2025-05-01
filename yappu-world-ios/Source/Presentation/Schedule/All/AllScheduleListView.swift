//
//  ScheduleListView.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import SwiftUI

struct AllScheduleListView: View {
    var datas: [ScheduleDateEntity]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [.init()], spacing: 0, content: {
                ForEach(datas, id:\.date) { data in
                    if data.schedules.isEmpty.not(), let item = data.schedules.first?.toCellData(isToday: data.isToday) {
                        YPScheduleCell(model: item, isLast: datas.last?.date == data.date)
                    }
                }
            })
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    AllScheduleListView(
        datas: []
    )
}
