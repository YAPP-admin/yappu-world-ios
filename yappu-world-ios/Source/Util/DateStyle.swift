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
    case activitySessionTime = "a h시"
    
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
