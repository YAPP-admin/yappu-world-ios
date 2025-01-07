//
//  ButtonStyle+Custom.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/7/25.
//

import SwiftUI

extension ButtonStyle where Self == YPButtonStyle {
    /// 폰트, 색상, padding 등을 커스텀 할 수 있는 버튼입니다. 버튼의 색상은 ColorStyle을 사용합니다.
    public static func yapp(
        font: Pretendard.Style = .pretendard16(.bold),
        horizontalPadding: CGFloat = 0,
        verticalPadding: CGFloat = 16,
        radius: CGFloat = 12,
        style: ColorStyle
    ) -> YPButtonStyle {
        YPButtonStyle(
            font: font,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            radius: radius,
            colorStyle: style
        )
    }
}
