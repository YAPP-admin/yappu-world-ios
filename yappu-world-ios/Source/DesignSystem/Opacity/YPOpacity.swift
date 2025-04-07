//
//  YPOpacity.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/7/25.
//

import SwiftUI
import Foundation

enum YPOpacity: Double {
    case opacity_0 = 0
    case opacity_05 = 0.05
    case opacity_08 = 0.08
    case opacity_12 = 0.12
    case opacity_16 = 0.16
    case opacity_22 = 0.22
    case opacity_28 = 0.28
    case opacity_35 = 0.35
    case opacity_43 = 0.43
    case opacity_52 = 0.52
    case opacity_61 = 0.61
    case opacity_74 = 0.74
    case opacity_88 = 0.88
    case opacity_97 = 0.97
    case opacity_100 = 1
}

// View에 적용
extension View {
    func ypOpacity(_ ypOpacity: YPOpacity) -> some View {
        self.opacity(ypOpacity.rawValue)
    }
}

// Color에 적용
extension Color {
    func ypOpacity(_ ypOpacity: YPOpacity) -> Color {
        self.opacity(ypOpacity.rawValue)
    }
}

// LinearGradientd에 적용
extension LinearGradient {
    func ypOpacity(_ ypOpacity: YPOpacity) -> some View {
        self.opacity(ypOpacity.rawValue)
    }
}

// RadialGradient에 적용
extension RadialGradient {
    func ypOpacity(_ ypOpacity: YPOpacity) -> some View {
        self.opacity(ypOpacity.rawValue)
    }
}


// AngularGradient에 적용
extension AngularGradient {
    func ypOpacity(_ ypOpacity: YPOpacity) -> some View {
        self.opacity(ypOpacity.rawValue)
    }
}
