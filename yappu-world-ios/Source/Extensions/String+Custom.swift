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
    
    var secureURL: URL? {
        if self.lowercased().hasPrefix("http://") || self.lowercased().hasPrefix("https://") {
            return URL(string: self)
        } else {
            return URL(string: "https://" + self)
        }
    }
}
