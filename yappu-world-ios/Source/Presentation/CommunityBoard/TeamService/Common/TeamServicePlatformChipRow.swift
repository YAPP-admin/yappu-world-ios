//
//  TeamServicePlatformChipRow.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

struct TeamServicePlatformChipRow: View {
    @Binding var selected: TeamServicePlatform?

    private let options: [TeamServicePlatform?] = [nil, .app, .web]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(options, id: \.self) { option in
                chip(for: option)
            }
        }
    }

    @ViewBuilder
    private func chip(for option: TeamServicePlatform?) -> some View {
        let isSelected = selected == option
        let title: String = option?.displayName ?? "전체"

        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(isSelected ? .yapp(.semantic(.primary(.normal))) : .clear)

            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(isSelected ? .yapp(.semantic(.primary(.normal))) : .gray22, lineWidth: 1)

            Text(title)
                .font(.pretendard13(.medium))
                .foregroundStyle(isSelected ? .white : .labelGray)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
        }
        .fixedSize()
        .contentShape(RoundedRectangle(cornerRadius: 14))
        .onTapGesture {
            withAnimation(.smooth(duration: 0.2)) {
                selected = option
            }
        }
    }
}

#Preview {
    @Previewable @State var selected: TeamServicePlatform? = nil
    TeamServicePlatformChipRow(selected: $selected)
        .padding()
}
