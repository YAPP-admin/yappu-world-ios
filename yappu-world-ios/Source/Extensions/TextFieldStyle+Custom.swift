//
//  TextFieldStyle+Custom.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/6/25.
//

import SwiftUI

extension TextFieldStyle where Self == YPTextFieldStyle {
    public static func yapp(
        type: YPTextFieldStyle.AccessoryType = .default,
        state: Binding<InputState>,
        cornerRadius: CGFloat = 10,
        usingTextFieldStatus: Bool = false
    ) -> YPTextFieldStyle {
        var padding: CGFloat {
            switch type {
            case .default: return 16
            default: return 0
            }
        }

        var backgroundColor: Color {
            switch type {
            case .default: return .white
            default: return .clear
            }
        }

        return YPTextFieldStyle(
            state: state,
            accessoryType: type,
            padding: padding,
            backgroundColor: backgroundColor,
            radius: cornerRadius,
            usingTextFieldStatus: usingTextFieldStatus
        )
    }

    public static func yapp(
        type: YPTextFieldStyle.AccessoryType = .default,
        state: Binding<InputState>,
        padding: CGFloat,
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = 10,
        usingTextFieldStatus: Bool = false
    ) -> YPTextFieldStyle {
        return YPTextFieldStyle(
            state: state,
            accessoryType: type,
            padding: padding,
            backgroundColor: backgroundColor,
            radius: cornerRadius,
            usingTextFieldStatus: usingTextFieldStatus
        )
    }
}
