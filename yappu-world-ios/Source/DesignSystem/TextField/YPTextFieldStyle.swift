//
//  YPTextFieldStyle.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/6/25.
//

import SwiftUI

public struct YPTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    @Binding private var state: InputState

    private let accessory: AccessoryType
    private let padding: CGFloat
    private let backgroundColor: Color
    private let cornerRadius: CGFloat

    public typealias Configuration = TextField<Self._Label>

    public func _body(configuration: Configuration) -> some View {
        HStack(spacing: .zero) {
            configuration
                .font(.pretendard16_19(.semibold))
                .padding(.vertical, padding)
                .padding(.leading, padding)
                .focused($isFocused)
                // 에러 상태일 땐, focus상태여도 error상태 그대로 유지
                .onChange(of: isFocused) { oldValue, newValue in
                    if case .error = state { return }
                    state = newValue ? .focus : .default
                }

            if case .default = accessory {
                Image("")
            }
            
        }
        .padding(.trailing, padding)
        .background(backgroundColor)
        .cornerRadius(radius: cornerRadius, corners: .allCorners)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(state.borderColor, lineWidth: 1)
        )
    }
}

public extension YPTextFieldStyle {
    init(
        state: Binding<InputState>,
        accessoryType: AccessoryType = .default,
        padding: CGFloat,
        backgroundColor: Color,
        radius: CGFloat
    ) {
        self._state = state
        self.accessory = accessoryType
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.cornerRadius = radius
    }

    enum AccessoryType {
        case `default`
        case none
    }
}
