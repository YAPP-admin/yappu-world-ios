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
            .if(colorStyle == .border) {
                $0.overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(foregroundColor, lineWidth: 1)
                )
            }
            .cornerRadius(radius: cornerRadius, corners: .allCorners)

    }
}

public extension YPButtonStyle {
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
        if colorStyle == .primary {
            switch isEnabled {
            case true: return .white
            case false: return .gray30
            }
        } else {
            return .yapp_primary
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
        .buttonStyle(.yapp(style: .primary))

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
