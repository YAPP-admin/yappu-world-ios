//
//  NoticeCell.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/6/25.
//

import SwiftUI

struct NoticeCell: View {
    
    var notice: NoticeEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 8) {
                badge(type: notice.boardType)
                noticeWriter(text: notice.writer)
                dot
                noticeCreatedDate(text: notice.createdAt)
            }
            
            mainTitle(text: notice.title)
            
            content(text: notice.content)
        }
        .background(.white)
    }
}

extension NoticeCell {
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
        .fixedSize()
    }
    
    private func noticeWriter(text: String) -> some View {
        Text(text)
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
            .font(.pretendard12(.regular))
            .foregroundStyle(Color.gray30)
    }
    
    private func mainTitle(text: String) -> some View {
        Text(text)
            .font(.pretendard15(.semibold))
            .foregroundStyle(Color.labelGray)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func content(text: String) -> some View {
        Text(text)
            .font(.pretendard14(.regular))
            .foregroundStyle(Color.labelGray)
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ZStack {
        Color.red.opacity(0.2)
        NoticeCell(notice: .dummy())
    }
    
}
