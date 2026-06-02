//
//  TeamServiceDetailView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI
import Kingfisher

/// Figma 9090:4251 - 역대 서비스 상세
struct TeamServiceDetailView: View {
    @Bindable
    var viewModel: TeamServiceDetailViewModel

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
        .backButton(title: "역대 서비스", action: viewModel.clickBackButton)
        .task(viewModel.onTask)
    }

    // MARK: - Content

    @ViewBuilder
    private func content(for service: TeamServiceEntity) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                headerChips(for: service)

                Text(service.name)
                    .font(.pretendard24(.bold))
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))

                Text(service.tagline)
                    .font(.pretendard17(.regular))
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            heroImage(for: service)

            if !service.links.isEmpty {
                HStack(spacing: 8) {
                    ForEach(service.links, id: \.kind) { link in
                        TeamServiceLinkButton(link: link) {
                            viewModel.clickLink(link)
                        }
                    }
                }
            }

            Text(service.description)
                .font(.pretendard15(.regular))
                .foregroundStyle(.yapp(.semantic(.label(.normal))))
                .lineSpacing(15 * 0.6)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            teamSection
        }
        .padding(.top, 16)
    }

    private func headerChips(for service: TeamServiceEntity) -> some View {
        HStack(spacing: 4) {
            YPChip("\(service.generation)기")
                .color(.neutral)
                .style(.weak)
            ForEach(service.platforms, id: \.self) { platform in
                YPChip(platform.displayName)
                    .color(platform.chipColor)
                    .style(platform.chipStyle)
            }
            Spacer()
        }
    }

    private func heroImage(for service: TeamServiceEntity) -> some View {
        Rectangle()
            .fill(Color.yapp(.semantic(.fill(.alternative))))
            .aspectRatio(320.0 / 200.0, contentMode: .fit)
            .overlay {
                KFImage(service.thumbnailURL)
                    .resizable()
                    .scaledToFill()
            }
            .overlay {
                if service.thumbnailURL == nil {
                    Image(systemName: "photo")
                        .font(.system(size: 36))
                        .foregroundStyle(.gray22)
                }
            }
            .clipRectangle(12)
    }

    private var teamSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Text("함께 한 팀원")
                    .font(.pretendard20(.semibold))
                    .foregroundStyle(.labelGray)
                Text("👋")
                    .font(.pretendard20(.semibold))
            }

            VStack(alignment: .leading, spacing: 10) {
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
