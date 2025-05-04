//
//  YPDivider.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import SwiftUI

struct YPDivider: View {
    
    var height: CGFloat
    var color: Color
    
    init(color: Color = .gray22, height: CGFloat = 1.0) {
        self.color = color
        self.height = height
    }
    
    var body: some View {
        Rectangle().frame(height: height)
            .foregroundColor(color)
    }
}

#Preview {
    YPDivider()
}
