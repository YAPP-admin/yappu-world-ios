//
//  YPScheduleCell.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/19/25.
//

import SwiftUI

enum YPScheduleCellViewType {
    case all
    case session
    case flat
    case today
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
        case .all, .session: normalTypeView
        case .today: todayTypeView
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
                    .frame(width: 70, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text(model.item.name)
                        .font(.pretendard14(.semibold))
                        .padding(.bottom, 6)
                    
                    if let place = model.item.place, place != "" {
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
            .opacity(model.item.scheduleProgressPhase == .done ? 0.5 : 1)
            
            if isLast.not() {
                YPDivider(color: .yapp(.semantic(.line(.alternative))))
            }
        }
        
    }
}

extension YPScheduleCell {
    var flatTypeView: some View {
        VStack(spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text(convertDay())
                    .font(.pretendard13(.regular))
                    .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                    .padding(.trailing, 8)
                
                Spacer()
                
                YPScheduleBadge(type: model.badgeType)
            }
            .padding(.vertical, 14)
            
            if isLast.not() {
                YPDivider(color: .yapp(.semantic(.line(.alternative))))
            }
        }
    }
}

extension YPScheduleCell {
    var todayTypeView: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(hex: "#FFF8F5"))
            
            VStack(alignment: .leading, spacing: 0) {
                
                HStack { Spacer() }
                
                Text(model.item.name)
                    .font(.pretendard16(.semibold))
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))
                    
                Text(convertDay())
                    .font(.pretendard12(.medium))
                    .foregroundStyle(.yapp(.semantic(.label(.neutral))))
                    .padding(.trailing, 8)
                    .padding(.top, 4)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    if let place = model.item.place, place != "" {
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
                .padding(.top, 12)
            }
            .padding(.all, 20)
        }
        .fixedSize(horizontal: false, vertical: true)
        
    }
}

extension YPScheduleCell {
    private func convertDay() -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        var dateFormat = "d (E)"
        
        switch model.viewType {
        case .all:
            dateFormat = "d (E)"
        case .session:
            dateFormat = "M.d (E)"
        case .today:
            dateFormat = "yyyy. M. d (E)"
        case .flat:
            
            var tempDateFormat = "M월 d일 (E) HH:mm"
            
            switch model.badgeType {
            case .nonattendance, .approvedAbsence:
                tempDateFormat = "M월 d일 (E)"
            default:
                break
            }
            
            dateFormat = tempDateFormat
        }
        
        dateFormatter.dateFormat = dateFormat
        
        switch model.viewType {
        case .flat:
            
            let ISOdateFormatter = DateFormatter()
            ISOdateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            ISOdateFormatter.locale = Locale(identifier: "en_US_POSIX")
            ISOdateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            
            guard let date = ISOdateFormatter.date(from: model.item.date ?? "") else { return "출석 정보 없음" }
            
            return dateFormatter.string(from: date)
            
        default:
            
            guard let date = inputFormatter.date(from: model.item.date ?? "") else { return "출석 정보 없음" }
            
            return dateFormatter.string(from: date)
        }
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

#Preview {
    ZStack {
        Color.red.opacity(0.2)
        YPScheduleCell(
            model: .init(
                viewType: .flat,
                badgeType: .attendance,
                isToday: false,
                item: .dummy(),
                task: nil
            )
            
            /*
             "sessionId": "552390a8-ff12-11ef-ad31-0242ac120002",
                 "name": "OT",
                 "startDate": "2025-05-08",
                 "startDayOfWeek": "목",
                 "endDate": "2025-05-08",
                 "endDayOfWeek": "목",
                 "startTime": "13:30:00",
                 "endTime": "17:00:00",
                 "place": "아몰랑",
                 "relativeDays": -1,
                 "canCheckIn": false,
                 "status": null
             */
        )
        .background(.white)
            .padding(.horizontal, 20)
    }
    
}
