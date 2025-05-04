//
//  Date + Custom.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/22/25.
//

import Foundation

extension Date {
    
    /// 주어진 포맷 형식에 따라 현재 Date 객체를 문자열로 변환합니다.
    /// - Parameter format: 변환할 날짜 형식 문자열 (예: "yyyy.MM.dd")
    /// - Returns: 포맷에 맞춰 변환된 문자열 (한국 시간 기준)
    func formatted(as format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
