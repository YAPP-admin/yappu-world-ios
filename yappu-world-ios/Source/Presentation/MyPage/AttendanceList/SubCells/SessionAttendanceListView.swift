//
//  SessionAttendanceListView.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import SwiftUI

struct SessionAttendanceListView: View {
    
    var histories: [ScheduleEntity]
    
    init(histories: [ScheduleEntity]) {
        self.histories = histories
    }
    
    var body: some View {
        LazyVGrid(columns: [.init()], content: {
            ForEach(histories, id:\.id) { data in
                let item = data.toCellData(isToday: false, viewType: .flat)
                YPScheduleCell(model: item, isLast: histories.last?.id == data.id)
                    .tag(data.id)
                    .id(data.id)
            }
            .padding(.horizontal, 20)
        })
    }
}

#Preview {
    SessionAttendanceListView(histories: [])
}
