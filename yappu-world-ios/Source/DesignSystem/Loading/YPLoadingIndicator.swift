//
//  YPLoadingIndicator.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/30/25.
//

import SwiftUI

struct YPLoadingIndicator: View {
    
    @State private var isAnimating: Bool = false
    private var size: CGFloat
    private var strokeWidth: CGFloat
    
    init(size: CGFloat = 20, strokeWidth: CGFloat = 2) {
        self.size = size
        self.strokeWidth = strokeWidth
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.yapp(.semantic(.label(.normal))).opacity(0.1), lineWidth: strokeWidth)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: 0.15)
                .stroke(.yapp(.semantic(.label(.normal))), lineWidth: strokeWidth)
                .frame(width: size, height: size)
                .rotationEffect(isAnimating ? .degrees(360) : .degrees(0))
                .animation(.linear(duration: 1.1).repeatForever(autoreverses: false), value: isAnimating)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    YPLoadingIndicator()
}
