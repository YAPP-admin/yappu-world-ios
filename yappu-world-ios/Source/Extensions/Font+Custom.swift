//
//  Font+Custom.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/6/25.
//

import SwiftUI

public protocol FontLineHeightConfigurable {
    var font: UIFont { get }
    var lineHeight: CGFloat { get }
}

struct FontWithLineHeight: ViewModifier {
    let fontConfigurable: FontLineHeightConfigurable

    func body(content: Content) -> some View {
        content
            .font(Font(fontConfigurable.font))
            .lineSpacing(fontConfigurable.lineHeight - fontConfigurable.font.lineHeight)
            .padding(.vertical, (fontConfigurable.lineHeight - fontConfigurable.font.lineHeight) / 2)
    }
}

extension View {
    public func font(_ pretendard: Pretendard.Style) -> some View {
        return modifier(FontWithLineHeight(fontConfigurable: pretendard as FontLineHeightConfigurable))
    }
}
