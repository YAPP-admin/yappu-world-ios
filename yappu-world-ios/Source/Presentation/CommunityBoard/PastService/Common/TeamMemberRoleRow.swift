//
//  TeamMemberRoleRow.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

struct TeamMemberRoleRow: View {
    let role: Position
    let members: [PastServiceTeamMember]
    let onTapMember: (String) -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(role.shortLabel)
                .font(.pretendard14(.semibold))
                .foregroundStyle(.labelGray)
                .frame(width: 56, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                ForEach(members) { member in
                    Button {
                        onTapMember(member.id)
                    } label: {
                        Text(member.name)
                            .font(.pretendard14(.regular))
                            .foregroundStyle(.labelGray)
                            .underline()
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()
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
