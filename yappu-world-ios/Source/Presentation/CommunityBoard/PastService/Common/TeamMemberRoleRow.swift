//
//  TeamMemberRoleRow.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

/// Figma 9090:4296 - 라벨(64px label/alternative) | 이름 버튼들(primary, no underline)
struct TeamMemberRoleRow: View {
    let role: Position
    let members: [PastServiceTeamMember]
    let onTapMember: (String) -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(role.shortLabel)
                .font(.pretendard14(.semibold))
                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                .frame(width: 64, alignment: .leading)

            HStack(spacing: 12) {
                ForEach(members) { member in
                    Button {
                        onTapMember(member.id)
                    } label: {
                        Text(member.name)
                            .font(.pretendard14(.semibold))
                            .foregroundStyle(.yapp(.semantic(.primary(.normal))))
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    VStack(alignment: .leading) {
        TeamMemberRoleRow(
            role: .iOS,
            members: [
                .init(id: "1", name: "김도형", position: .iOS),
                .init(id: "2", name: "이얍얍", position: .iOS),
            ],
            onTapMember: { _ in }
        )
    }
    .padding()
}
