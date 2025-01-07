//
//  ButtonStyle+Custom.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/7/25.
//

import SwiftUI

extension ButtonStyle where Self == YPButtonStyle {
    /// 폰트, 색상, padding 등을 커스텀 할 수 있는 버튼입니다. 버튼의 색상은 ColorStyle을 사용합니다.
    /// font: Pretendard 스타일 폰트 설정입니다. ex) .pretendard16(.bold)
    /// horizontalPadding: 버튼을 horizontal 기준으로 몇 padding 시킬지에 대한 값입니다.
    /// verticalPadding: 버튼을 vertical 기준으로 몇 padding 시킬지에 대한 값입니다.
    /// radius: 버튼의 radius 값입니다.
    /// colorStyle: 버튼이 노출되는 스타일을 설정합니다. ex) .primary or .border
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
