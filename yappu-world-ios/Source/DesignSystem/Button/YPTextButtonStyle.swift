//
//  YPTextButtonStyle.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/1/25.
//

import SwiftUI

struct YPTextButtonStyle: ButtonStyle {
    @Environment(\.isEnabled)
    private var isEnabled
    
    private let style: Style
    private let size: Size
    
    init(style: Style, size: Size) {
        self.style = style
        self.size = size
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .foregroundStyle(style.color(isEnabled))
            .padding(.horizontal, 7)
            .padding(.vertical, 4)
            .if(configuration.isPressed) { view in
                view.background {
                    style.backgroundColor
                        .clipRectangle(4)
                }
            }
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

extension YPTextButtonStyle {
    enum Style {
        case primary
        case assistive
        case normal
        
        func color(_ isEnabled: Bool) -> Color {
            switch self {
            case .primary:
                return isEnabled
                ? .yapp(.semantic(.primary(.normal)))
                : .yapp(.semantic(.label(.disable)))
            case .assistive:
                return isEnabled
                ? .yapp(.semantic(.label(.alternative)))
                : .yapp(.semantic(.label(.disable)))
            case .normal:
                return isEnabled
                ? .yapp(.semantic(.interaction(.disable)))
                : .yapp(.semantic(.label(.disable)))
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return .yapp(.semantic(.primary(.normal))).opacity(0.12)
            case .assistive:
                return .yapp(.semantic(.label(.normal))).opacity(0.09)
            case .normal:
                return .yapp(.semantic(.interaction(.disable))).opacity(0.12)
            }
        }
    }
    
    enum Size {
        case medium
        case small
        
        var font: Font {
            switch self {
            case .medium:
                return Font(Pretendard.Style.pretendard16(.bold).font)
            case .small:
                return Font(Pretendard.Style.pretendard14(.bold).font)
            }
        }
    }
}

#Preview {
    VStack {
        Button("Label") {
            
        }
        .buttonStyle(.text(style: .primary, size: .medium))
        
        Button("Label") {
            
        }
        .buttonStyle(.text(style: .primary, size: .small))
        
        Button("Label") {
            
        }
        .buttonStyle(.text(style: .assistive, size: .medium))
        
        Button("Label") {
            
        }
        .buttonStyle(.text(style: .assistive, size: .small))
        
        Button("Label") {
            
        }
        .buttonStyle(.text(style: .normal, size: .medium))
        
        Button("Label") {
            
        }
        .buttonStyle(.text(style: .normal, size: .small))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.yapp(.semantic(.background(.elevated(.normal)))))
}
