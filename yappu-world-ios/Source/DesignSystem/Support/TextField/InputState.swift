//
//  InputState.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/6/25.
//

import SwiftUI

/// TextField의 상태값을 나타내는 타입
public enum InputState: Equatable, Hashable {
    /// TextField가 선택되지 않았고 , error도 없는 상태
    case `default`
    case focus
    case typing
    case success(String)
    case error(String)

    public var borderColor: Color {
        switch self {
        case .default, .success: return .gray22
        case .focus, .typing: return .yapp_primary
        case .error: return .red100
        }
    }
}
