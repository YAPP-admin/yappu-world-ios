//
//  DisplayTargetBadgeView.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/3/25.
//

import SwiftUI

struct DisplayTargetBadgeView: View {
    
    var target: DisplayTargetType
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(foregroundColor())
            
            Text(target.text)
                .foregroundStyle(foregroundColor(opacity: false))
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
                .font(.pretendard11(.semibold))
        }
        .fixedSize()
    }
    
}

private extension DisplayTargetBadgeView {
    private func foregroundColor(opacity: Bool = true) -> Color {
        switch target {
        case .All:
            return .yapp(.semantic(.label(.disable))).opacity(opacity ? 0.16 : 1)
        case .Certificated:
            return .certifiedMemberColor.opacity(opacity ? 0.1 : 1)
        case .Player:
            return .yapp(.semantic(.primary(.normal))).opacity(opacity ? 0.1 : 1)
        }
    }
}

#Preview {
    ZStack {
        Color.red.opacity(0.2)
        VStack {
            DisplayTargetBadgeView(target: .All)
            DisplayTargetBadgeView(target: .Certificated)
            DisplayTargetBadgeView(target: .Player)
        }
        .background(.white)
    }
    
    
}
