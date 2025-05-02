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
        
        VStack {
            
            InformationLabel(title: "세션 출석 내역", titleFont: .pretendard16(.semibold))
                .padding(.horizontal, 20)
            
            LazyVGrid(columns: [.init()], content: {
                if histories.isEmpty {
                    Text("아직 출석 내역이 없어요.")
                        .font(.pretendard13(.regular))
                        .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                        .padding(.vertical, 12)
                } else {
                    ForEach(histories, id:\.id) { data in
                        let item = data.toCellData(isToday: false, viewType: .flat)
                        YPScheduleCell(model: item, isLast: histories.last?.id == data.id)
                            .tag(data.id)
                            .id(data.id)
                    }
                    .padding(.horizontal, 20)
                }
                
            })
        }
        
        
    }
}

#Preview {
    SessionAttendanceListView(histories: [])
}
