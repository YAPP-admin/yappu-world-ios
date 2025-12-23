//
//  YPCarousel.swift
//  yappu-world-ios
//
//  Created by 김건형 on 8/7/25.
//

import SwiftUI

struct YPCarousel<T: Identifiable, Content: View>: View {
    @Binding var scrollIndex: Int?
    @Binding var isIncrease: Bool
    var isDarkDot: Bool = false
    var isDotHidden: Bool = false
    var items: [T]
    var content: (T) -> Content
    
    var body: some View {
        let isFirstIndex = (scrollIndex ?? 0) == 0
        let isSingleItem = items.count == 1
        
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(items.indices, id: \.self) { index in
                        content(items[index])
                            .id(index)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 16)
                .padding(.leading, (isFirstIndex && !isSingleItem) ? 20 : 0)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            
            if !isDotHidden {
                scrollIndicator
            }
        }
        .contentMargins(
            isSingleItem ? .horizontal : (isFirstIndex ? .trailing : .horizontal),
            isSingleItem ? 20 : (isFirstIndex ? 130 : 65)
        )
        .scrollPosition(
            id: $scrollIndex,
            anchor: isSingleItem ? .center : .leading
        )
        .onAppear {
            print("isFirstIndex: \(isFirstIndex), isSingleItem: \(isSingleItem)")
        }
        .onChange(of: scrollIndex) { oldValue, newValue in
            guard let newValue, let oldValue else { return }
            isIncrease = oldValue < newValue
        }
    }
    
    @ViewBuilder
    var scrollIndicator: some View {
        let scrollIndex = self.scrollIndex ?? 0
        
        HStack(spacing: 8) {
            Group {
                scrollIndicatorDot(!isIncrease)
                
                scrollIndicatorDot(isIncrease)
            }
            .frame(width: 8, height: 8)
        }
        .animation(.smooth, value: scrollIndex)
        .animation(.smooth, value: isIncrease)
    }
     
    @ViewBuilder
    func scrollIndicatorDot(_ isActive: Bool) -> some View {
        let color: Color = .yapp(.semantic(.static(isDarkDot ? .black : .white))).opacity(
            isActive ? 1 : 0.16
        )
        
        Circle().fill(color)
    }
}
