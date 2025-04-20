//
//  SchedulesEntity.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import Foundation

struct SchedulesEntity {
    let dates: [ScheduleDateEntity]
}

struct ScheduleDateEntity {
    let date: String
    let schedules: [ScheduleEntity]
}

struct ScheduleEntity: Hashable, Equatable {
    let id: String
    let name: String
    let place: String?
    let date: String?
    let endDate: String?
    let time: String?
    let endTime: String?
    let scheduleType: String?
    let sessionType: String?
    let scheduleProgressPhase: String?
}

extension ScheduleEntity {
    func toCellData(viewType: YPScheduleCellViewType = .normal) -> YPScheduleModel {
        .init(viewType: viewType, badgeType: .none, isToday: isDateToday(dateString: date ?? ""), item: self)
    }
    
    private func isDateToday(dateString: String) -> Bool {
        // 날짜 포맷터 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // JSON 날짜 문자열을 Date 객체로 변환
        guard let date = dateFormatter.date(from: dateString) else {
            return false
        }
        
        // 현재 날짜 가져오기
        let now = Date()
        
        // 두 날짜가 같은 날인지 확인 (Calendar 사용)
        let calendar = Calendar.current
        return calendar.isDate(date, inSameDayAs: now)
    }
}
