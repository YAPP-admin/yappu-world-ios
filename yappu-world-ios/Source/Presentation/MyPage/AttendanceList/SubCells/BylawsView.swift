//
//  BylawsView.swift
//  yappu-world-ios
//
//  Created by 김도연 on 4/7/26.
//

import SwiftUI

struct BylawsView: View {

    let items: [BylawItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("꼭 확인하세요")
                .font(.pretendard15(.semibold))
                .foregroundStyle(.yapp(.semantic(.label(.normal))))

            VStack(alignment: .leading, spacing: 8) {
                ForEach(items.indices, id: \.self) { index in
                    bylawRow(item: items[index])
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(Color.yapp(.semantic(.fill(.normal))))
    }

    private func bylawRow(item: BylawItem) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text("•")
                .font(.pretendard13(.regular))
                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                .padding(.leading, 4)

            styledText(item.text, bold: item.boldParts)
                .font(.pretendard13(.regular))
                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func styledText(_ fullText: String, bold boldParts: [String]) -> Text {
        var result = Text("")
        var remaining = fullText

        while !remaining.isEmpty {
            let match = boldParts
                .compactMap { part -> (String, Range<String.Index>)? in
                    guard let range = remaining.range(of: part) else { return nil }
                    return (part, range)
                }
                .min(by: { $0.1.lowerBound < $1.1.lowerBound })

            if let (part, range) = match {
                let before = String(remaining[remaining.startIndex..<range.lowerBound])
                if !before.isEmpty { result = result + Text(before) }
                result = result + Text(part).bold()
                remaining = String(remaining[range.upperBound...])
            } else {
                result = result + Text(remaining)
                break
            }
        }

        return result
    }
}

#Preview {
    BylawsView(items: BylawItem.attendanceBylaws)
}
