//
//  YPScheduleCell.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/19/25.
//

import SwiftUI

enum YPScheduleCellViewType {
    case normal
    case flat
}

struct YPScheduleModel: Hashable, Equatable {
    var viewType: YPScheduleCellViewType
    var badgeType: YPScheduleBadgeType
    var isToday: Bool
    var item: ScheduleEntity
    var task: YPScheduleTaskModel?
}

struct YPScheduleTaskModel: Hashable, Equatable {
    var title: String
    var message: String
}

struct YPScheduleCell: View {
    
    let model: YPScheduleModel
    let isLast: Bool
    
    init(model: YPScheduleModel, isLast: Bool = false) {
        self.model = model
        self.isLast = isLast
    }
    
    var body: some View {
        switch model.viewType {
        case .normal: normalTypeView
        case .flat: flatTypeView
        }
    }
}

extension YPScheduleCell {
    var normalTypeView: some View {
        VStack {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(convertDay())
                    .font(.pretendard14(.semibold))
                    .foregroundStyle(model.isToday ? .yapp(.semantic(.primary(.normal))) : .yapp(.semantic(.label(.normal))))
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text(model.item.name)
                        .font(.pretendard14(.semibold))
                        .padding(.bottom, 6)
                    
                    if let place = model.item.place {
                        HStack(spacing: 4) {
                            Image("location_icon")
                            Text(place)
                                .font(.pretendard12(.regular))
                                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                        }
                    }
                    
                    if let time = convertTime() {
                        HStack(spacing: 4) {
                            Image("time_icon")
                            Text(time)
                                .font(.pretendard12(.regular))
                                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                        }
                        .padding(.top, 4)
                    }
                    
                    
                    if let task = model.task {
                        VStack(alignment: .leading, spacing : 6) {
                            Text(task.title)
                                .font(.pretendard14(.semibold))
                                .foregroundStyle(.yapp(.semantic(.label(.normal))))
                            Text(task.message)
                                .font(.pretendard12(.regular))
                                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                        }
                        .padding(.top, 12)
                    }
                }
                
                Spacer()
                
                YPScheduleBadge(type: model.badgeType)
            }
            .padding(.vertical, 16)
            .opacity(model.item.scheduleProgressPhase ?? "" == "DONE" ? 0.5 : 1)
            
            if isLast.not() {
                YPDivider(color: .yapp(.semantic(.line(.alternative))))
            }
        }
        
    }
}

extension YPScheduleCell {
    private func convertDay() -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "d (E)"
        guard let date = inputFormatter.date(from: model.item.date ?? "") else { return "" }
        
        return dateFormatter.string(from: date)
    }
    
    private func convertTime() -> String? {
        var timeString: String? = nil
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "a h시"
        
        if let time = model.item.time {
            guard let startDate = timeFormatter.date(from: time) else { return nil }
            let tempStrtDateString = outputFormatter.string(from: startDate)
            timeString = tempStrtDateString
        }
        
        if let endTime = model.item.endTime {
            guard let endDate = timeFormatter.date(from: endTime) else { return nil }
            let tempEndDateString = outputFormatter.string(from: endDate)
            timeString = "\(timeString ?? "") - \(tempEndDateString)"
        }
        
        return timeString
    }
}

extension YPScheduleCell {
    var flatTypeView: some View {
        Text("Hello")
    }
}

#Preview {
    ZStack {
        Color.red.opacity(0.2)
        YPScheduleCell(
            model: .init(
                viewType: .normal,
                badgeType: .attendance,
                isToday: true,
                item: .init(
                    id: "dsaddsadsa",
                    name: "데이터 테스트",
                    place: nil,
                    date: nil,
                    endDate: nil,
                    time: nil,
                    endTime: nil,
                    scheduleType: nil,
                    sessionType: nil,
                    scheduleProgressPhase: "DONE"
                ),
                task: nil
            )
        )
        .background(.white)
            .padding(.horizontal, 20)
    }
    
}
