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
    private var usingTextFieldStatus: Bool

    private let accessory: AccessoryType
    private let padding: CGFloat
    private let backgroundColor: Color
    private let cornerRadius: CGFloat

    public typealias Configuration = TextField<Self._Label>

    public func _body(configuration: Configuration) -> some View {
        HStack(spacing: .zero) {
            if usingTextFieldStatus {
                Group {
                    switch state {
                    case .typing:
                        YPLoadingIndicator()
                            .transition(.opacity.combined(with: .scale))
                    case .error:
                        YPStatusView(status: .Failed)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .scale),
                                removal: .opacity.combined(with: .scale(scale: 0.8))
                            ))
                    case .success:
                        YPStatusView(status: .Success)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .scale),
                                removal: .opacity.combined(with: .scale(scale: 0.8))
                            ))
                    case .default, .focus:
                        EmptyView()
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: state)
            }
            
            configuration
                .textInputAutocapitalization(.never)
                .font(.pretendard16_19(.semibold))
                .tint(.labelGray)
                .padding(.leading, textFieldLeadingPadding())
                .padding(.vertical, padding)
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
        .padding(.leading, padding)
        .padding(.trailing, padding)
        .background(backgroundColor)
        .cornerRadius(radius: cornerRadius, corners: .allCorners)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(state.borderColor, lineWidth: 1)
        )
    }
    
    private func textFieldLeadingPadding() -> CGFloat {
        switch state {
        case .typing, .success, .error: 12
        default: 0
        }
    }
}

public extension YPTextFieldStyle {
    init(
        state: Binding<InputState>,
        accessoryType: AccessoryType = .default,
        padding: CGFloat,
        backgroundColor: Color,
        radius: CGFloat,
        usingTextFieldStatus: Bool = false
    ) {
        self._state = state
        self.accessory = accessoryType
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.cornerRadius = radius
        self.usingTextFieldStatus = usingTextFieldStatus
    }

    enum AccessoryType {
        case `default`
        case none
    }
}

#Preview {
    
    @Previewable @State var state: InputState = .default
    @Previewable @State var text: String = ""
    
    TextField("이메일", text: $text)
        .textFieldStyle(.yapp(type: .default, state: $state, cornerRadius: 8, usingTextFieldStatus: true))
}
