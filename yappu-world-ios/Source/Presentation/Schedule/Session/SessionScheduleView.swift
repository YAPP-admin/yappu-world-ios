//
//  SessionScheduleView.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/19/25.
//

import SwiftUI

struct SessionScheduleView: View {
    
    @State var viewModel: SessionScheduleViewModel = .init()
    
    var body: some View {
        ScrollView {
            if viewModel.isInit {
                LazyVGrid(columns: [.init()], spacing: 0, content: {
                    ForEach(viewModel.sessions, id:\.id) { data in
                        let item = data.toCellData(isToday: data.relativeDays ?? 0 == 0, viewType: .session)
                        YPScheduleCell(model: item, isLast: viewModel.sessions.last?.date == data.date)
                            .tag(data.id)
                            .id(data.id)
                    }
                })
                .padding(.horizontal, 20)
            }
        }
        .task { await viewModel.onTask() }
    }
}

#Preview {
    SessionScheduleView()
}
