//
//  Color+YAPP.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/6/25.
//

import SwiftUI

// MARK: - Gray Scale
public extension Color {
    static let gray22: Color = .init(hex: "#70737C").opacity(0.22)
    static let gray30: Color = .init(hex: "#37383C").opacity(0.28)
    static let gray60: Color = .init(hex: "#37383C").opacity(0.61)
}

// MARK: - Main Color
public extension Color {
    static let yapp_primary: Color = .init(hex: "#FA6027")
}

// MARK: - System Color
public extension Color {
    static let labelGray: Color = .init(hex: "#171719")
    static let disabledGray: Color = .init(hex: "#F4F4F5")
    static let orGray: Color = .init(hex: "#E0E0E2")
    static let red100: Color = .init(hex: "#FF4242")
}
