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
    ///   - input:  입력 패턴 (기본: "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX")
    ///   - locale/timeZone/calendar: 필요 시 조정
    func reformatDate(
        output: String,
        input: String = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",
        locale: Locale = Locale(identifier: "ko_KR"),
        timeZone: TimeZone = .autoupdatingCurrent,
        calendar: Calendar = .autoupdatingCurrent
    ) -> String {
        // 1) 입력 파싱용 포매터
        let inputFormatter = DateFormatter()
        inputFormatter.locale = locale
        inputFormatter.timeZone = timeZone
        inputFormatter.dateFormat = input

        guard let date = inputFormatter.date(from: self) else {
            return self // 실패 시 원본 반환
        }

        // 2) 출력 포매터
        let outputFormatter = DateFormatter()
        outputFormatter.locale = locale
        outputFormatter.timeZone = timeZone
        outputFormatter.dateFormat = output

        return outputFormatter.string(from: date)
    }
    
    /// ISO8601(Z/오프셋, 밀리초 유무) → Date
    var isoDate: Date? {
        let withMs = ISO8601DateFormatter()
        withMs.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        withMs.timeZone = TimeZone(secondsFromGMT: 0)

        let noMs = ISO8601DateFormatter()
        noMs.formatOptions = [.withInternetDateTime]
        noMs.timeZone = TimeZone(secondsFromGMT: 0)

        return withMs.date(from: self) ?? noMs.date(from: self)
    }
    
    var secureURL: URL? {
        if self.lowercased().hasPrefix("http://") || self.lowercased().hasPrefix("https://") {
            return URL(string: self)
        } else {
            return URL(string: "https://" + self)
        }
    }
}
