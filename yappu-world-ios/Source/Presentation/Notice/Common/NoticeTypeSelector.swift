//
//  NoticeTypeSelector.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import SwiftUI

enum NoticeType {
    case 전체
    case 운영
    case 세션
    
    // 추후 API 문서 나오면 교체하겠습니다.
    var paramterValue: String {
        switch self {
        case .전체: ""
        case .운영: "운영"
        case .세션: "세션"
        }
    }
    
    var stringValue: String {
        switch self {
        case .전체: "전체"
        case .운영: "운영"
        case .세션: "세션"
        }
    }
}

struct NoticeTypeSelector: View {
    
    var types: [NoticeType] = [.전체, .운영, .세션]
    
    @Binding var selectedType: NoticeType
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(types, id: \.self) { type in
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(selectedType == type ? .yapp_primary : .clear)
                    
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(selectedType == type ? .yapp_primary : .gray22, lineWidth: 1)
                    
                    Text(type.stringValue)
                        .font(.pretendard13(.medium))
                        .foregroundStyle(selectedType == type ? .white : .labelGray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                }
                .fixedSize()
                .contentShape(RoundedRectangle(cornerRadius: 12))
                .onTapGesture {
                    withAnimation(.smooth(duration: 0.2)) {
                        selectedType = type
                    }
                }
            }
        }
        .background(.white)
    }
}

#Preview {
    @Previewable @State var selectedType: NoticeType = .전체
    ZStack {
        Color.red.opacity(0.2)
        NoticeTypeSelector(selectedType: $selectedType)
    }
    
}
