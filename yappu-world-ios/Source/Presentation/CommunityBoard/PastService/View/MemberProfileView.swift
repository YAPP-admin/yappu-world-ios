//
//  MemberProfileView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

/// Figma 9098:3188 / 9098:3698 - 회원 프로필 상세
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
        VStack(alignment: .leading, spacing: 24) {
            header(for: member)
                .padding(.horizontal, 20)

            LazyVStack(spacing: 12) {
                ForEach(viewModel.sortedActivities) { activity in
                    MemberActivityRow(
                        activity: activity,
                        onTapSnippet: viewModel.clickSnippet
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 16)
    }

    private func header(for member: MemberProfileEntity) -> some View {
        HStack(spacing: 16) {
            // TODO: Kingfisher SPM 추가 후 KFImage(url: member.profileImageURL)로 교체
            Image("Profile")
                .resizable()
                .frame(width: 66, height: 66)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(member.name)
                        .font(.pretendard28(.bold))
                        .foregroundStyle(.yapp(.semantic(.label(.normal))))
                    MemberBadgeView(member: .convert(member.role), size: .large)
                    Spacer(minLength: 0)
                }

                HStack(spacing: 4) {
                    Text("\(member.latestGeneration)기")
                        .font(.pretendard14(.regular))
                    Text("·")
                        .font(.pretendard16(.regular))
                    Text(member.latestPosition.shortLabel)
                        .font(.pretendard14(.regular))
                    Spacer(minLength: 0)
                }
                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
            }
        }
    }

    private var placeholder: some View {
        VStack {
            Spacer().frame(height: 120)
            ProgressView()
        }
        .frame(maxWidth: .infinity)
    }
}
