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
            
            mainTitle(text: notice.title)
            content(text: notice.content)
        }
        .background(.white)
    }
}

extension NoticeCell {
    
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
