//
//  DateStyle.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/4/25.
//

import Foundation

enum DateStyle: String, CaseIterable {
    case sessionDate = "yyyy-MM-dd"
    case sessionTime = "HH:mm:ss"
    case activitySessionDate = "yyyy. MM. dd (E)"
    case activitySessionTime = "a h시 m분"
    
    static var cachedFormatter: [DateStyle: DateFormatter] {
        var formatters = [DateStyle: DateFormatter]()
        for style in Self.allCases {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = style.rawValue
            formatters[style] = formatter
        }
        return formatters
    }
}

extension Date {
    func toString(
        _ style: DateStyle,
        identifier: String? = nil
    ) -> String {
        guard let formatter = DateStyle.cachedFormatter[style] else {
            return ""
        }
        if let identifier {
            formatter.locale = Locale(identifier: identifier)
        }
        return formatter.string(from: self)
    }
    
    func getCurrentTimeString() -> String {
        let calendar = Calendar.current
        
        // 시와 분을 추출
        let components = calendar.dateComponents(
            [.hour, .minute],
            from: self
        )
        
        // 시와 분이 제대로 추출되었는지 확인
        guard
            let hour = components.hour,
            let minute = components.minute
        else { return "" }
        
        // 오전/오후 및 12시간 형식으로 변환
        let isPM = hour >= 12
        let amPM = isPM ? "오후" : "오전"
        let displayHour = hour % 12 == 0 ? 12 : hour % 12 // 0시 또는 12시는 12로, 나머지는 1~11
        
        // 분이 0이면 시만 표시, 아니면 시와 분 모두 표시
        if minute == 0 {
            return "\(amPM) \(displayHour)시"
        } else {
            return "\(amPM) \(displayHour)시 \(minute)분"
        }
    }
}

extension String {
    func toDate(
        _ style: DateStyle,
        identifier: String? = nil
    ) -> Date? {
        guard let formatter = DateStyle.cachedFormatter[style] else {
            return nil
        }
        if let identifier {
            formatter.locale = Locale(identifier: identifier)
        }
        return formatter.date(from: self)
    }
    
    func convertDateFormat(
        from currentStyle: DateStyle,
        to style: DateStyle,
        identifier: String? = nil
    ) -> String {
        return self
            .toDate(currentStyle, identifier: identifier)?
            .toString(style, identifier: identifier) ?? self
    }
}
