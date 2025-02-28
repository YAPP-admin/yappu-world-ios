//
//  YPButtonStyle.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/7/25.
//

import SwiftUI

public enum ColorStyle {
    case primary
    case border
    case secondary
}

public struct YPButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    private let font: Pretendard.Style
    private let verticalPadding: CGFloat
    private let horizontalPadding: CGFloat
    private let cornerRadius: CGFloat
    private let colorStyle: ColorStyle

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(font)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .if(colorStyle != .primary) {
                $0.overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: 1)
                )
            }
            .cornerRadius(radius: cornerRadius, corners: .allCorners)

    }
}

public extension YPButtonStyle {
    /// 출석앱에서 주로 사용하는 버튼의 Style
    /// font: Pretendard 스타일 폰트 설정입니다. ex) .pretendard16(.bold)
    /// horizontalPadding: 버튼을 horizontal 기준으로 몇 padding 시킬지에 대한 값입니다.
    /// verticalPadding: 버튼을 vertical 기준으로 몇 padding 시킬지에 대한 값입니다.
    /// radius: 버튼의 radius 값입니다.
    /// colorStyle: 버튼이 노출되는 스타일을 설정합니다. ex) .primary or .border
    init(
        font: Pretendard.Style,
        horizontalPadding: CGFloat,
        verticalPadding: CGFloat,
        radius: CGFloat,
        colorStyle: ColorStyle
    ) {
        self.font = font
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.cornerRadius = radius
        self.colorStyle = colorStyle
    }

    private var foregroundColor: Color {
        switch colorStyle {
        case .primary:
            switch isEnabled {
            case true: return .white
            case false: return .gray30
            }
        case .secondary:
            return isEnabled
            ? .yapp(.semantic(.primary(.normal)))
            : .yapp(.semantic(.label(.disable)))
        default: return .yapp_primary
        }
    }
    
    private var borderColor: Color {
        switch colorStyle {
        case .primary:
            switch isEnabled {
            case true: return .white
            case false: return .gray30
            }
        case .secondary:
            return .yapp(.semantic(.line(.normal)))
        default: return .yapp_primary
        }
    }

    private var backgroundColor: Color {
        if colorStyle == .primary {
            switch isEnabled {
            case true: return .yapp_primary
            case false: return .disabledGray
            }
        } else {
            return .white
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        Button(action: {}, label: {
            Text("다음")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.yapp(style: .secondary))
        
        Button(action: {}, label: {
            Text("다음")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.yapp(style: .primary))
        
        Button(action: {}, label: {
            Text("다음")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.yapp(style: .border))

        Button(action: {}, label: {
            Text("다음")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.yapp(style: .primary))
        .disabled(true)

        Button(action: {}, label: {
            Text("인증메일 발송")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.yapp(style: .primary))
        .disabled(true)

        Button(action: {}, label: {
            Text("요청거절")
        })
        .buttonStyle(.yapp(
            horizontalPadding: 22,
            style: .primary
        ))
        .disabled(true)

        Button(action: {}, label: {
            Text("요청승인")
        })
        .buttonStyle(.yapp(
            horizontalPadding: 70,
            style: .primary
        ))

        Button(action: {}, label: {
            Text("검색")
        })
        .buttonStyle(.yapp(
            font: .pretendard16(.bold),
            horizontalPadding: 14,
            verticalPadding: 15,
            style: .border
        ))

        Button(action: {}, label: {
            Text("검색")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.yapp(
            font: .pretendard16(.semibold),
            horizontalPadding: 14,
            verticalPadding: 15,
            style: .border
        ))
    }
}
