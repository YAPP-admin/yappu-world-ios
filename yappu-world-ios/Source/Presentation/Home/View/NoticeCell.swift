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
            NoticeBadge(notice: notice)
            
            mainTitle(text: notice.notice.title)
            content(text: notice.notice.content)
//            //MARK: [의논] 어떤 Property로 트리거를 할지 정하기
//            if isLoading {
//                VStack(alignment: .leading, spacing: 8) {
//                    content(text: "") // 2번쨰 스켈레톤
//                    content(text: "") // 3번쨰 스켈레톤
//                }
//            }
        }
        .background(.white)
    }
}

extension NoticeCell {
    
    private func mainTitle(text: String) -> some View {
        Text(text)
            .setYPSkeletion(isLoading: notice.notice.id.isEmpty)
            .font(.pretendard15(.semibold))
            .foregroundStyle(Color.labelGray)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func content(text: String) -> some View {
        Text(text)
            .setYPSkeletion(isLoading: notice.notice.id.isEmpty)
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
