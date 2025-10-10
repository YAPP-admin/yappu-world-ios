//
//  String+Custom.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/3/25.
//

import Foundation

extension String {
    func repeated(count: Int) -> String {
        String(repeating: self, count: count)
    }
    
    /// HH:mm:ss -> time dateFormat
    func toTimeFormat(as dateFormat: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "ko_KR")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = dateFormat
        outputFormatter.locale = Locale(identifier: "ko_KR")
        
        guard let date = inputFormatter.date(from: self) else {
            return self // 실패 시 원본 반환
        }
        
        return outputFormatter.string(from: date)
    }
    
    /// "yyyy-MM-dd" 형식의 날짜 문자열을 원하는 출력 포맷으로 변환
    /// - Parameters:
    ///   - output: 출력 패턴 (예: "yyyy. MM. dd (E)")
    ///   - input:  입력 패턴 (기본: "yyyy-MM-dd")
    ///   - locale/timeZone/calendar: 필요 시 조정
    func reformatDate(
        output: Date.FormatString,
        input: Date.FormatString = "yyyy-MM-dd",
        locale: Locale = Locale(identifier: "ko_KR"),
        timeZone: TimeZone = .autoupdatingCurrent,
        calendar: Calendar = .autoupdatingCurrent
    ) -> String {
        // 1) String -> Date
        let parse = Date.ParseStrategy(
            format: input,
            locale: locale,
            timeZone: timeZone,
            calendar: calendar
        )
        
        guard let date = try? Date(self, strategy: parse) else { return self }

        // 2) Date -> String (직접 패턴 사용)
        let style = Date.VerbatimFormatStyle(
            format: output,
            locale: locale,
            timeZone: timeZone,
            calendar: calendar
        )
        
        return date.formatted(style)
    }
    
    var secureURL: URL? {
        if self.lowercased().hasPrefix("http://") || self.lowercased().hasPrefix("https://") {
            return URL(string: self)
        } else {
            return URL(string: "https://" + self)
        }
    }
}
