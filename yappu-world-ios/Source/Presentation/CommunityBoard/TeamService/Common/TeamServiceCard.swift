//
//  TeamServiceCard.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

struct TeamServiceCard: View {
    let service: TeamServiceEntity
    var isLoading: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            thumbnail
                .overlay(alignment: .bottomLeading) {
                    HStack(spacing: 4) {
                        ForEach(service.platforms, id: \.self) { platform in
                            YPChip(platform.displayName)
                                .color(platform.chipColor)
                                .style(platform.chipStyle)
                        }
                    }
                    .padding(8)
                }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    YPChip("\(service.generation)기")
                        .color(.neutral)
                        .style(.weak)
                    Spacer()
                }
                .padding(.top, 8)

                Text(service.name)
                    .font(.pretendard16(.semibold))
                    .foregroundStyle(.labelGray)
                    .lineLimit(1)

                Text(service.tagline)
                    .font(.pretendard12(.regular))
                    .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .setYPSkeletion(isLoading: isLoading)
    }

    private var thumbnail: some View {
        Rectangle()
            .fill(Color.yapp(.semantic(.fill(.alternative))))
            .aspectRatio(152.0 / 114.0, contentMode: .fit)
            .clipRectangle(8)
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 28))
                    .foregroundStyle(.gray22)
            }
    }
}

#Preview {
    HStack {
        TeamServiceCard(service: .dummy())
        TeamServiceCard(service: .dummy(platforms: [.web]))
    }
    .padding()
}
