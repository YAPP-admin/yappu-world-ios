//
//  YPButtonModifier.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/18/25.
//

import SwiftUI


public struct YPButtonModifier: ViewModifier {
    
    var style: ColorStyle
    @Binding var state: InputState
    
    public func body(content: Content) -> some View {
        content
            .buttonStyle(.yapp(radius: state == .default ? 8 : 0, style: .primary ))
            .padding(.bottom, state == .default ? 16 : 0)
            .padding(.horizontal, state == .default ? 20 : 0)
            .animation(.interactiveSpring, value: state)
    }
}

extension View {
    func YPkeyboardAnimationButtonStyle(style: ColorStyle = .primary, state: Binding<InputState>) -> some View {
        modifier(YPButtonModifier(style: style, state: state))
    }
}
