//
//  TextEditorStyle+Custom.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/8/25.
//

import SwiftUI
import Foundation

struct YPTextEditorStyle: TextEditorStyle {
    
    @Binding var state: YPTextEditorState
    var padding: CGFloat
    var backgroundColor: Color
    var cornerRadius: CGFloat
    
    init(state: Binding<YPTextEditorState>, padding: CGFloat, backgroundColor: Color, cornerRadius: CGFloat) {
        self._state = state
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
    
    func makeBody(configuration: TextEditorStyleConfiguration) -> some View {
        
        ZStack {
            Rectangle()
                .background(.clear)
                .cornerRadius(cornerRadius)
                //.cornerRadius(radius: cornerRadius, corners: .allCorners)
                
        }
        
    }
    
}

extension TextEditorStyle where Self == YPTextEditorStyle {
    static func yapp(
        state: Binding<YPTextEditorState>,
        padding: CGFloat = 0,
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = 10
    ) -> YPTextEditorStyle {
        return .init(state: state,
                     padding: padding,
                     backgroundColor: backgroundColor,
                     cornerRadius: cornerRadius)
    }
}

#Preview {
    @Previewable @State var state: YPTextEditorState = .default
    @Previewable @State var text: String = ""
    VStack {
        TextEditor(text: $text)
            .textEditorStyle(.yapp(state: $state))
    }
}
