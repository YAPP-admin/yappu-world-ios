//
//  MemberActivityRow.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

/// Figma 9098:3634 - 회원 프로필 활동 카드. white bg + alternative border.
struct MemberActivityRow: View {
    let activity: MemberActivityEntity
    let onTapSnippet: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("\(activity.generation)기")
                    .font(.pretendard20(.semibold))
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))

                if let position = activity.position {
                    YPChip(position.shortLabel)
                        .color(.neutral)
                        .style(.fill)
                }
                if activity.isOperation {
                    YPChip("운영진")
                        .color(.orange)
                        .style(.weak)
                }
                Spacer()
                Text("\(activity.periodStart) - \(activity.periodEnd)")
                    .font(.pretendard13(.regular))
                    .foregroundStyle(.yapp(.semantic(.line(.normal))))
            }

            if let service = activity.service {
                MemberActivityServiceSnippet(service: service, onTap: onTapSnippet)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.yapp(.semantic(.background(.normal(.normal)))))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.yapp(.semantic(.line(.normal))).opacity(0.08), lineWidth: 1)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        MemberActivityRow(
            activity: .init(
                generation: 25,
                position: .UIUX_Design,
                isOperation: false,
                periodStart: "23.11.01",
                periodEnd: "24.06.30",
                service: .dummy(platforms: [.app, .web])
            ),
            onTapSnippet: { _ in }
        )
        MemberActivityRow(
            activity: .init(
                generation: 20,
                position: nil,
                isOperation: true,
                periodStart: "23.11.01",
                periodEnd: "24.06.30",
                service: nil
            ),
            onTapSnippet: { _ in }
        )
    }
    .padding()
}
