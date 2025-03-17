//
//  YPDivider.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import SwiftUI

struct YPDivider: View {
    
    var color: Color
    
    init(color: Color = .gray22) {
        self.color = color
    }
    
    var body: some View {
        Rectangle().frame(height: 1)
            .foregroundColor(color)
    }
}

#Preview {
    YPDivider()
}
