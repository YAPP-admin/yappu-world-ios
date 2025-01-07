//
//  HeaderLabel.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/6/25.
//

import SwiftUI

/// Header에 위치하는 Label입니다. 필수적으로 입력해야 하는  Content가 존재하는 경우, isRequired 속성을 true로 설정합니다.
public struct HeaderLabel: View {
    private let value: String
    private let isRequired: Bool
    private let font: Pretendard.Style
    private let headerColor: Color

    public var body: some View {
        HStack(spacing: 0) {
            Text(value)
                .font(font)
                
            if isRequired {
                Text(" *")
                    .font(font)
                    .foregroundStyle(Color.red100)
            }
        }
        .foregroundStyle(headerColor)
    }
}

public extension HeaderLabel {
    init(
        title: String,
        isRequired: Bool = false,
        font: Pretendard.Style = .pretendard16(.semibold),
        headerColor: Color = .gray60
    ) {
        self.value = title
        self.isRequired = isRequired
        self.font = font
        self.headerColor = headerColor
    }
}

#Preview {
    HeaderLabel(
        title: "이메일",
        isRequired: true,
        font: .pretendard16(.semibold)
    )
}
