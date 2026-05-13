//
//  PastServiceDetailView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

struct PastServiceDetailView: View {
    @Bindable
    var viewModel: PastServiceDetailViewModel

    var body: some View {
        ScrollView {
            if let service = viewModel.service {
                content(for: service)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
            } else {
                placeholder
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
            }
        }
        .backButton(title: "역대서비스", action: viewModel.clickBackButton)
        .task(viewModel.onTask)
    }

    // MARK: - Content

    @ViewBuilder
    private func content(for service: PastServiceEntity) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            headerChips(for: service)

            VStack(alignment: .leading, spacing: 8) {
                Text(service.name)
                    .font(.pretendard24(.bold))
                    .foregroundStyle(.labelGray)
                Text(service.tagline)
                    .font(.pretendard14(.regular))
                    .foregroundStyle(.yapp(.semantic(.label(.alternative))))
            }

            heroImage

            if !service.links.isEmpty {
                HStack(spacing: 8) {
                    ForEach(service.links, id: \.kind) { link in
                        PastServiceLinkButton(link: link) {
                            viewModel.clickLink(link)
                        }
                    }
                }
            }

            Text(service.description)
                .font(.pretendard14(.regular))
                .foregroundStyle(.labelGray)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            teamSection
        }
        .padding(.top, 12)
    }

    private func headerChips(for service: PastServiceEntity) -> some View {
        HStack(spacing: 6) {
            YPChip("\(service.generation)기")
                .color(.neutral)
                .style(.weak)
            ForEach(service.platforms, id: \.self) { platform in
                YPChip(platform.displayName)
                    .color(platform.chipColor)
                    .style(.fill)
            }
            Spacer()
        }
    }

    private var heroImage: some View {
        Rectangle()
            .fill(Color.yapp(.semantic(.fill(.alternative))))
            .aspectRatio(320.0 / 200.0, contentMode: .fit)
            .clipRectangle(12)
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 36))
                    .foregroundStyle(.gray22)
            }
    }

    private var teamSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("함께 한 팀원 👋")
                .font(.pretendard16(.semibold))
                .foregroundStyle(.labelGray)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(viewModel.groupedTeam, id: \.role) { group in
                    TeamMemberRoleRow(
                        role: group.role,
                        members: group.members,
                        onTapMember: viewModel.clickMember
                    )
                }
            }
        }
        .padding(.top, 8)
    }

    // MARK: - Placeholder

    private var placeholder: some View {
        VStack {
            Spacer().frame(height: 120)
            ProgressView()
        }
        .frame(maxWidth: .infinity)
    }
}
