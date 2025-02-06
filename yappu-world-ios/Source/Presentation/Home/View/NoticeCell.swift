//
//  NoticeCell.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/6/25.
//

import SwiftUI

enum BadgeType {
    case Notice
    case Session
    
    var text: String {
        switch self {
        case .Notice:
            return "운영"
        case .Session:
            return "세션"
        }
    }
}

struct NoticeCell: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 8) {
                badge(type: .Notice)
                noticeWriter(text: "20기 홍길동")
                dot
                noticeCreatedDate(text: "2023-08-12")
            }
            
            mainTitle(text: "심장 건강을 책임지는 스마트 워치,심박수 감시와 예das스마트 워치,심박수 감시와 예das스마트 워치,심박수 감시와 예das스마트 워치,심박수 감시와 예das스마트 워치,심박수 감시와 예das스마트 워치,심박수 감시와 예das")
            
            content(text: "한반도의 경제 협력이 새로운 국면을 맞이하며 남북 간 첫 연합 기업이 설립되었습니다. 이 기업은 에너지, 통신, 제한반도의 경제 협력이 새로운 국면을 맞이하며 남북 간 첫 연합 기업이 설립되었습니다. 이 기업은 에너지, 통신, 제한반도의 경제 협력이 새로운 국면을 맞이하며 남북 간 첫 연합 기업이 설립되었습니다. 이 기업은 에너지, 통신, 제한반도의 경제 협력이 새로운 국면을 맞이하며 남북 간 첫 연합 기업이 설립되었습니다. 이 기업은 에너지, 통신, 제")
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
            .font(.pretendard12(.semibold))
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
        NoticeCell()
    }
    
}
