//
//  MemberBadgeView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

/// 회원 종류(관리자/운영진/활동회원 등) 뱃지.
/// HomeView와 MyPageProfileView에 중복 정의되어 있던 헬퍼를 공용화.
struct MemberBadgeView: View {
    enum Size {
        case small      // HomeView (홈 헤더 등 컴팩트한 영역)
        case regular    // MyPageProfileView (프로필 헤더)
        case large      // MemberProfileView 헤더 - Figma 9098:3225 (primary fill + 흰 글자)
    }

    let member: Member
    var size: Size = .regular

    var body: some View {
        switch size {
        case .small:
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(member.color.opacity(0.10))

                Text(member.description)
                    .font(.pretendard11(.medium))
                    .foregroundStyle(member.color)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 8)
            }
            .fixedSize()
            .padding(.vertical, 9)

        case .regular:
            Text(member.description)
                .font(.pretendard13(.medium))
                .foregroundStyle(member.color)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(member.color.opacity(0.10))
                )
                .fixedSize()

        case .large:
            Text(member.description)
                .font(.pretendard13(.medium))
                .foregroundStyle(.white)
                .padding(.vertical, 3)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(member.color)
                )
                .fixedSize()
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        HStack {
            MemberBadgeView(member: .Active, size: .small)
            MemberBadgeView(member: .Staff, size: .small)
            MemberBadgeView(member: .Admin, size: .small)
        }
        HStack {
            MemberBadgeView(member: .Active)
            MemberBadgeView(member: .Staff)
            MemberBadgeView(member: .Admin)
        }
        HStack {
            MemberBadgeView(member: .Active, size: .large)
            MemberBadgeView(member: .Staff, size: .large)
            MemberBadgeView(member: .Admin, size: .large)
        }
    }
    .padding()
}
