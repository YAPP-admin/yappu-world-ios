//
//  PreActivityCell.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import SwiftUI

struct PreActivityCell: View {
    
    // MARK: Property
    var activity: PreActivityEntity
    var isLoading: Bool
    
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 8) {
                HStack {
                    Position(text: activity.position)
                    Spacer()
                    HStack(spacing: 0) {
                        Spacer()
                        Image("Symbol")
                        Generation(text: activity.generation)
                    }
                }
                Date(start: activity.activityStartDate, end: activity.activityEndDate)
            }
            .padding(16)
        }
        .background(Color.activetyCellBackgroundColor)
        .cornerRadius(12)
    }
}
// MARK: - Private UI Builders
extension PreActivityCell {
    
    /// 직군
    private func Position(text: String) -> some View {
        Text(text)
            .setYPSkeletion(isLoading: isLoading)
            .font(.pretendard17(.bold))
            .foregroundStyle(Color.labelGray)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// 기수
    private func Generation(text: Int) -> some View {
        Text("\(text)기")
            .setYPSkeletion(isLoading: isLoading)
            .font(.pretendard14(.medium))
            .foregroundStyle(Color.labelGray)
            .lineLimit(1)
    }
    
    @ViewBuilder
    private func Date(start: String?, end: String?) -> some View {
        if let start = start, let end = end {
            Text("\(start) - \(end)")
                .setYPSkeletion(isLoading: isLoading)
                .font(.pretendard13(.regular))
                .foregroundStyle(Color.gray52)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    PreActivityCell(activity: .dummy(), isLoading: false)
}
