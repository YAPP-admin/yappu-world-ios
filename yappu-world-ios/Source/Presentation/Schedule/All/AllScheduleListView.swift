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
                    if data.schedules.isEmpty.not(), let item = data.schedules.first?.toCellData() {
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
        datas: [.init(
            date: "2025-04-20",
            schedules: [.init(
                id: "dsaddsadsa",
                name: "데이터 테스트",
                place: "place테스트",
                date: "2025-04-20",
                endDate: "2025-04-20",
                time: "16:00:00",
                endTime: "18:00:00",
                scheduleType: "SESSION",
                sessionType: "TEAM",
                scheduleProgressPhase: "DONE"
            )]
        )]
    )
}
