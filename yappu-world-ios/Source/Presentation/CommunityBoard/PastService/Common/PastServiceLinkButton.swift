//
//  PastServiceLinkButton.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

struct PastServiceLinkButton: View {
    let link: PastServiceLink
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: iconName)
                    .font(.system(size: 14, weight: .semibold))
                Text(link.kind.displayName)
                    .font(.pretendard14(.medium))
            }
            .foregroundStyle(.labelGray)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.yapp(.semantic(.fill(.alternative))))
            .clipRectangle(8)
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
