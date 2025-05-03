//
//  InformationLabel.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/7/25.
//

import SwiftUI

/// 공용으로 사용하는 메인 타이틀 View 입니다.
struct InformationLabel: View {
    
    private let step: Int?
    private let mainTitle: String
    private let mainTitleFont: Pretendard.Style
    private let subTitle: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            if let step = step {
                Text("STEP \(step)")
                    .font(.pretendard14(.bold))
                    .foregroundStyle(Color.yapp_primary)
            }
            
            Text(mainTitle)
                .foregroundStyle(.yapp(.semantic(.label(.normal))))
                .font(mainTitleFont)
            
            if let subTitle = subTitle {
                Text(subTitle)
                    .font(.pretendard15(.regular))
                    .foregroundStyle(Color.gray60)
            }
            
            HStack {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        
    }
}

extension InformationLabel {
    init(customStep step: Int? = nil, title mainTitle: String, titleFont: Pretendard.Style = .pretendard28(.bold), sub subTitle: String? = nil) {
        self.step = step
        self.mainTitle = mainTitle
        self.mainTitleFont = titleFont
        self.subTitle = subTitle
    }
}

#Preview {
    InformationLabel(
        customStep: 2,
        title: "당신의 작은 아이디어가\n세상을 바꿉니다.",
        sub: "YAPP에서 활동중인 기수와 직군 정보를 알려주세요.\n이전 활동 내역이 있다면 함께 추가 할수 있어요."
    )
}
