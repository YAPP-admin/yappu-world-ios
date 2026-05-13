//
//  MemberActivityRow.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

struct MemberActivityRow: View {
    let activity: MemberActivityEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text("\(activity.generation)기")
                    .font(.pretendard16(.semibold))
                    .foregroundStyle(.labelGray)

                if let position = activity.position {
                    YPChip(position.shortLabel)
                        .color(position.chipColor)
                        .style(.weak)
                }
                if activity.isOperation {
                    YPChip("운영진")
                        .color(.violet)
                        .style(.weak)
                }
                Spacer()
                Text("\(activity.periodStart) - \(activity.periodEnd)")
                    .font(.pretendard12(.regular))
                    .foregroundStyle(Color.gray52)
            }

            if let service = activity.service {
                MemberActivityServiceSnippet(service: service)
            }
        }
        .padding(16)
        .background(Color.yapp(.semantic(.background(.elevated(.alternative)))))
        .clipRectangle(12)
    }
}

#Preview {
    VStack(spacing: 12) {
        MemberActivityRow(activity: .init(
            generation: 25,
            position: .UIUX_Design,
            isOperation: false,
            periodStart: "23.11.01",
            periodEnd: "24.06.30",
            service: .dummy(platforms: [.app, .web])
        ))
        MemberActivityRow(activity: .init(
            generation: 20,
            position: nil,
            isOperation: true,
            periodStart: "23.11.01",
            periodEnd: "24.06.30",
            service: nil
        ))
    }
    .padding()
}
