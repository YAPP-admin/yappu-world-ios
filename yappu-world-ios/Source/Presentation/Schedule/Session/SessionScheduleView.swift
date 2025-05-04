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
            LazyVGrid(columns: [.init()], spacing: 0, content: {
                
                HStack(alignment: .lastTextBaseline) {
                    
                    Text("오늘의 세션")
                        .font(.pretendard17(.semibold))
                        .foregroundStyle(.yapp(.semantic(.label(.normal))))
                        .padding(.top, 20)
                        
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.yapp(.semantic(.primary(.normal))))
                        
                        Text("D-day")
                            .font(.pretendard13(.medium))
                            .foregroundStyle(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                    }
                    .fixedSize()
                    .offset(x: 0, y: -1)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Group {
                    if let upcomming = viewModel.upcommingSession {
                        let item = upcomming.toCellData(isToday: false, viewType: .today)
                        YPScheduleCell(model: item, isLast: true)
                    } else if viewModel.isInit {
                        Text("오늘은 예정된 세션이 없어요.")
                            .font(.pretendard13(.medium))
                            .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                            .frame(height: 42, alignment: .center)
                    }
                }
                .padding(.all, 20)
                
                
                YPDivider(color: .yapp(.semantic(.line(.alternative))), height: 12)
                
                if viewModel.isInit {
                    
                    InformationLabel(title: "세션 전체 내역", titleFont: .pretendard17(.semibold))
                        .padding([.top, .leading, .bottom], 20)
                    
                    ForEach(viewModel.sessions, id:\.id) { data in
                        let item = data.toCellData(isToday: data.relativeDays ?? 0 == 0, viewType: .session)
                        YPScheduleCell(model: item, isLast: viewModel.sessions.last?.id == data.id)
                            .tag(data.id)
                            .id(data.id)
                    }
                    .padding(.horizontal, 20)
                }
            })
        }
        .task { await viewModel.onTask() }
    }
}

#Preview {
    SessionScheduleView()
}
