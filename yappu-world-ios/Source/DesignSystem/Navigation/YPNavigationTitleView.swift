//
//  YPNavigationTitleView.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/4/25.
//

import SwiftUI

struct YPNavigationTitleView: View {
    
    var text: String
    var font: Pretendard.Style
    
    init(text: String, font: Pretendard.Style = .pretendard20(.bold)) {
        self.text = text
        self.font = font
    }
    
    var body: some View {
        Text(text)
            .font(font)
            .foregroundStyle(.yapp(.semantic(.label(.normal))))
            .lineLimit(1)
            .frame(height: 56)
    }
}

#Preview {
    YPNavigationTitleView(text: "Title")
}
