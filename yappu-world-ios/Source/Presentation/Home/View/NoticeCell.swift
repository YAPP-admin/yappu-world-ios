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
            NoticeBadge(notice: notice, isLoading: isLoading)
            
            mainTitle(text: notice.notice.title)
            
            content(text: notice.notice.content)
        }
        .background(.white)
    }
}

extension NoticeCell {
    
    private func mainTitle(text: String) -> some View {
        Text(text)
            .font(.pretendard15(.semibold))
            .foregroundStyle(Color.labelGray)
            .setYPSkeletion(isLoading: isLoading)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func content(text: String) -> some View {
        Text(text)
            .font(.pretendard14(.regular))
            .foregroundStyle(Color.labelGray)
            .setYPSkeletion(isLoading: isLoading)
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ZStack {
        Color.red.opacity(0.2)
        NoticeCell(notice: .dummy(), isLoading: false)
    }
    
}
