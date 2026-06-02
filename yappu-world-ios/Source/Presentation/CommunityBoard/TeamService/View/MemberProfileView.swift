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
        List {
            if let member = viewModel.member {
                Section {
                    header(for: member)
                        .listRowInsets(EdgeInsets(top: 16, leading: 20, bottom: 24, trailing: 20))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }

                Section {
                    ForEach(viewModel.sortedActivities) { activity in
                        MemberActivityRow(
                            activity: activity,
                            onTapSnippet: viewModel.clickSnippet
                        )
                        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
            } else {
                Section {
                    placeholder
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .backButton(title: "\(viewModel.member?.name ?? "")님 프로필", action: viewModel.clickBackButton)
        .task(viewModel.onTask)
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

                if let generation = member.latestGeneration,
                   let position = member.latestPosition {
                    HStack(spacing: 4) {
                        Text("\(generation)기")
                            .font(.pretendard14(.regular))
                        Text("·")
                            .font(.pretendard16(.regular))
                        Text(position.shortLabel)
                            .font(.pretendard14(.regular))
                        Spacer(minLength: 0)
                    }
                    .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                }
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
