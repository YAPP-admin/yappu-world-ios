//
//  Color+YAPP.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/6/25.
//

import SwiftUI

// MARK: - Gray Scale
public extension Color {
    static let gray08: Color = .init(hex: "#70737C").opacity(0.08)
    static let gray22: Color = .init(hex: "#70737C").opacity(0.22)
    static let gray30: Color = .init(hex: "#37383C").opacity(0.28)
    static let gray52: Color = .init(hex: "#70737C").opacity(0.52)
    static let gray60: Color = .init(hex: "#37383C").opacity(0.61)
}

public extension ShapeStyle where Self == Color {
    static var gray08: Color { .gray08 }
    static var gray22: Color { .gray22 }
    static var gray30: Color { .gray30 }
    static var gray60: Color { .gray60 }
}

// MARK: - Main Color
public extension Color {
    static let yapp_primary: Color = .init(hex: "#FA6027")
}
public extension ShapeStyle where Self == Color {
    static var yapp_primary: Color { .yapp_primary }
}

// MARK: - System Color
public extension Color {
    static let labelGray: Color = .init(hex: "#171719")
    static let disabledGray: Color = .init(hex: "#F4F4F5")
    static let orGray: Color = .init(hex: "#E0E0E2")
    static let red100: Color = .init(hex: "#FF4242")
    static let mainBackgroundNormal: Color = .init(hex: "#F7F7F8")
}

public extension ShapeStyle where Self == Color {
    static var labelGray: Color { .labelGray }
    static var disabledGray: Color { .disabledGray }
    static var orGray: Color { .orGray }
    static var red100: Color { .red100 }
}
