//
//  NoticeBadge.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import SwiftUI


struct NoticeBadge: View {
    var notice: NoticeEntity
    
    var body: some View {
        HStack(spacing: 8) {
            badge(type: notice.notice.noticeType)
            noticeWriter(text: "\(notice.writer.activityUnitGeneration)기 \(notice.writer.name)")
            dot
            noticeCreatedDate(text: notice.notice.createdAt)
        }
    }
}

extension NoticeBadge {
    private func badge(type: BadgeType) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.mainBackgroundNormal)
            
            Text(type.text)
                .font(.pretendard11(.semibold))
                .foregroundStyle(Color.gray30)
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
        }
//            .setSkeleton(isLoading: isLoading) [의논] 어떤 Property로 트리거를 할지 정하기
        .fixedSize()
    }
    
    private func noticeWriter(text: String) -> some View {
        Text(text)
//            .setSkeleton(isLoading: isLoading) [의논] 어떤 Property로 트리거를 할지 정하기
            .font(.pretendard12(.regular))
            .foregroundStyle(Color.gray30)
    }
    
    private var dot: some View {
        Text("∙")
            .font(.pretendard12(.semibold))
            .foregroundStyle(Color.gray30)
            .offset(x: 0, y: -2)
    }
    
    private func noticeCreatedDate(text: String) -> some View {
        Text(text)
//            .setSkeleton(isLoading: isLoading) [의논] 어떤 Property로 트리거를 할지 정하기
            .font(.pretendard12(.regular))
            .foregroundStyle(Color.gray30)
    }
}
