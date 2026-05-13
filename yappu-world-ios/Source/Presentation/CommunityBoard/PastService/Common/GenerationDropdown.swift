//
//  GenerationDropdown.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

/// Figma 9181:3109 - "25기 ▼" 텍스트 18 Medium + caret 아이콘
struct GenerationDropdown: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.pretendard18(.medium))
                    .foregroundStyle(.labelGray)
                Image(systemName: "chevron.down")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(.labelGray)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    GenerationDropdown(title: "25기", action: {})
        .padding()
}
