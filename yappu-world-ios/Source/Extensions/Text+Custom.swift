//
//  Text+Custom.swift
//  yappu-world-ios
//
//  Created by 김도연 on 4/18/26.
//

import SwiftUI

/// 하나의 텍스트 내에서 특정 부분의 색상만 다르게 표시합니다.
/// - Parameters:
///   - fullText: 전체 텍스트
///   - highlights: 색상을 바꿀 (부분 문자열, 색상) 배열
///   - defaultColor: 나머지 텍스트에 적용할 기본 색상
/// - Returns: 색상이 적용된 `Text`
func coloredText(
    _ fullText: String,
    highlights: [(String, Color)],
    defaultColor: Color = Color(.label)
) -> Text {
    var result = Text("")
    var remaining = fullText

    while !remaining.isEmpty {
        let match = highlights
            .compactMap { (part, color) -> (String, Range<String.Index>, Color)? in
                guard let range = remaining.range(of: part) else { return nil }
                return (part, range, color)
            }
            .min(by: { $0.1.lowerBound < $1.1.lowerBound })

        if let (part, range, color) = match {
            let before = String(remaining[remaining.startIndex..<range.lowerBound])
            if !before.isEmpty {
                result = result + Text(before).foregroundColor(defaultColor)
            }
            result = result + Text(part).foregroundColor(color)
            remaining = String(remaining[range.upperBound...])
        } else {
            result = result + Text(remaining).foregroundColor(defaultColor)
            break
        }
    }

    return result
}
