//
//  PastServiceLinkButton.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

/// Figma 9090:4273 - Outlined Primary (App Store / Play Store / Web)
struct PastServiceLinkButton: View {
    let link: PastServiceLink
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: iconName)
                    .font(.system(size: 14, weight: .regular))
                Text(link.kind.displayName)
                    .font(.pretendard13(.semibold))
            }
            .foregroundStyle(.yapp(.semantic(.primary(.normal))))
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.yapp(.semantic(.primary(.normal))), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private var iconName: String {
        switch link.kind {
        case .appStore: "applelogo"
        case .playStore: "play.square.fill"
        case .web: "globe"
        }
    }
}

#Preview {
    HStack {
        if let url = URL(string: "https://apple.com") {
            PastServiceLinkButton(link: .init(kind: .appStore, url: url), action: {})
            PastServiceLinkButton(link: .init(kind: .playStore, url: url), action: {})
            PastServiceLinkButton(link: .init(kind: .web, url: url), action: {})
        }
    }
    .padding()
}
