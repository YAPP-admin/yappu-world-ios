//
//  SessionScheduleView.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/19/25.
//

import SwiftUI

struct SessionScheduleView: View {
    
    @State var viewModel: SessionScheduleViewModel = .init()
    @State private var scrollIndex: Int?
    @State private var isIncrease: Bool = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [.init()], spacing: 0, content: {
                
                HStack(alignment: .lastTextBaseline) {
                    
                    Text("오늘의 세션")
                        .font(.pretendard17(.semibold))
                        .foregroundStyle(.yapp(.semantic(.label(.normal))))
                        .padding(.top, 20)
                    
                    //MARK: (수정)D-day 라벨이 출력되는 로직이 논리적으로 이상하여 추후에 수정할 것 같음
                    if !viewModel.todaySession.isEmpty {
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
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Group {
                    if !viewModel.todaySession.isEmpty {
                        YPCarousel(
                            scrollIndex: $scrollIndex,
                            isIncrease: $isIncrease,
                            isDarkDot: true,
                            isDotHidden: viewModel.todaySession.count == 1,
                            items: viewModel.todaySession
                        ) { item in
                            activitySessionListCell(item)
                        }
                    } else if viewModel.isInit {
                        Text("오늘은 예정된 세션이 없어요.")
                            .font(.pretendard13(.medium))
                            .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                            .frame(height: 42, alignment: .center)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                    }
                }
                .padding(.bottom, 20)
                
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
        .refreshable { await viewModel.onTask(refresh: true) }
    }
}
// MARK: - Configure Views
private extension SessionScheduleView {
    func activitySessionListCell(_ item: ScheduleEntity) -> some View {
        var phase = item.scheduleProgressPhase ?? .pending
        if phase == .done && item.relativeDays ?? 0 < 0 {
            phase = .pending
        }
        
        return VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Text(phase.title)
                    .font(.pretendard11(.medium))
                    .foregroundStyle(.common100)
                    .frame(height: 14)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 8)
                    .background(phase.color)
                    .clipRectangle(6)
                
                Text(item.name)
                    .font(.pretendard16(.semibold))
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))
            }
            
            let date = item.date?.convertDateFormat(
                from: .sessionDate,
                to: .activitySessionDate
            ) ?? ""
            
            Text(date)
                .font(.pretendard12(.medium))
                .foregroundStyle(.yapp(.semantic(.label(.neutral))))
            
            Spacer()
            
            sessionInfoCell(
                image: .location,
                content: item.place ?? ""
            )
            
            let time = item.time?
                .toDate(.sessionTime)?
                .getCurrentTimeString() ?? ""
            let endTime = item.endTime?
                .toDate(.sessionTime)?
                .getCurrentTimeString() ?? ""
            sessionInfoCell(
                image: .history,
                content: "\(time) - \(endTime)"
            )
        }
        .padding(12)
        .frame(height: 120)
        .containerRelativeFrame(
            .horizontal,
            alignment: .leading
        )
        .background(Color.activityCellBackgroundColor)
        .clipRectangle(10)
    }
    
    func sessionInfoCell(image: ImageResource, content: String) -> some View {
        HStack(spacing: 4) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
            
            Text(content)
                .font(.pretendard12(.regular))
        }
        .foregroundStyle(.yapp(.semantic(.interaction(.inactive))))
    }
}

#Preview {
    SessionScheduleView()
}
