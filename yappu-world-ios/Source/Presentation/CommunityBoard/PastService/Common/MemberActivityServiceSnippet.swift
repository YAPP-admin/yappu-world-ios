//
//  MemberActivityServiceSnippet.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

/// Figma 9159:4461 - 활동 카드 내부 서비스 스니펫. 전체 영역 탭 가능 (스니펫 → 역대서비스 상세).
struct MemberActivityServiceSnippet: View {
    let service: ServiceSnippet
    let onTap: (String) -> Void

    var body: some View {
        Button {
            onTap(service.serviceId)
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 8) {
                    Text(service.name)
                        .font(.pretendard16(.semibold))
                        .foregroundStyle(.yapp(.semantic(.primary(.normal))))
                    Text(service.teamName)
                        .font(.pretendard12(.regular))
                        .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                    Spacer()
                    platformIcons
                }
                Text(service.description)
                    .font(.pretendard14(.regular))
                    .foregroundStyle(.yapp(.semantic(.label(.assistive))))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.yapp(.semantic(.background(.normal(.alternative)))))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var platformIcons: some View {
        HStack(spacing: 4) {
            if service.platforms.contains(.app) {
                Image(systemName: "applelogo")
                    .font(.system(size: 12))
                    .foregroundStyle(.yapp(.semantic(.label(.disable))))
                Image(systemName: "play.square.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.yapp(.semantic(.label(.disable))))
            }
            if service.platforms.contains(.web) {
                Image(systemName: "globe")
                    .font(.system(size: 12))
                    .foregroundStyle(.yapp(.semantic(.label(.disable))))
            }
        }
        .frame(height: 16)
    }
}

#Preview {
    MemberActivityServiceSnippet(
        service: .dummy(platforms: [.app, .web]),
        onTap: { _ in }
    )
    .padding()
}
