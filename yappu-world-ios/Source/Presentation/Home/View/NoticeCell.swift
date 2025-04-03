//
//  NoticeCell.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/6/25.
//

import SwiftUI

struct NoticeCell: View {
    
    var notice: NoticeEntity
    var isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            NoticeBadge(notice: notice)
            
            mainTitle(text: notice.notice.title)
            content(text: notice.notice.content)
            loadingInfoView()
        }
        .background(.white)
    }
}

extension NoticeCell {
    
    private func mainTitle(text: String) -> some View {
        Text(text)
            .setYPSkeletion(isLoading: isLoading)
            .font(.pretendard15(.semibold))
            .foregroundStyle(Color.labelGray)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func content(text: String) -> some View {
        Text(text)
            .setYPSkeletion(isLoading: isLoading)
            .font(.pretendard14(.regular))
            .foregroundStyle(Color.labelGray)
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func loadingInfoView() -> some View {
        Group { // 조건문 안팎이 일관된 뷰 타입으로 인식
            if isLoading {
                VStack(alignment: .leading, spacing: 8) {
                    content(text: notice.writer.activityUnitPosition.name)
                    content(text: notice.writer.activityUnitPosition.label)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.red.opacity(0.2)
        NoticeCell(notice: .dummy(), isLoading: false)
    }
    
}
