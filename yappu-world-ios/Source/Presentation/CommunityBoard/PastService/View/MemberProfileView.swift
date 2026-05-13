//
//  MemberProfileView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

struct MemberProfileView: View {
    @Bindable
    var viewModel: MemberProfileViewModel

    var body: some View {
        ScrollView {
            if let member = viewModel.member {
                content(for: member)
                    .padding(.bottom, 32)
            } else {
                placeholder
            }
        }
        .backButton(title: "\(viewModel.member?.name ?? "")님 프로필", action: viewModel.clickBackButton)
        .task(viewModel.onTask)
    }

    @ViewBuilder
    private func content(for member: MemberProfileEntity) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            header(for: member)
                .padding(.horizontal, 20)

            LazyVStack(spacing: 12) {
                ForEach(viewModel.sortedActivities) { activity in
                    MemberActivityRow(activity: activity)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 12)
    }

    private func header(for member: MemberProfileEntity) -> some View {
        HStack(spacing: 16) {
            Image("Profile")
                .resizable()
                .frame(width: 56, height: 56)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(member.name)
                        .font(.pretendard18(.semibold))
                        .foregroundStyle(.labelGray)
                    memberBadge(member: .convert(member.role))
                    Spacer()
                }

                HStack(spacing: 5) {
                    Text("\(member.latestGeneration)기")
                    Text("∙").offset(x: 0, y: -2.5)
                    Text(member.latestPosition.shortLabel)
                    Spacer()
                }
                .font(.pretendard16(.regular))
                .foregroundStyle(.gray60)
            }
        }
    }

    private func memberBadge(member: Member) -> some View {
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
    }

    private var placeholder: some View {
        VStack {
            Spacer().frame(height: 120)
            ProgressView()
        }
        .frame(maxWidth: .infinity)
    }
}
