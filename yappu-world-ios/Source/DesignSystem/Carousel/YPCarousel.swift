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
                .padding(.leading, isFirstIndex ? 20 : 0)
                .scrollTargetLayout()
            }
            
            if !isDotHidden {
                scrollIndicator
            }
        }
        .contentMargins(
            isFirstIndex ? .trailing : .horizontal,
            isFirstIndex ? 130 : 65
        )
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $scrollIndex, anchor: .center)
        .onAppear {
            print(isFirstIndex)
        }
    }
    
    @ViewBuilder
    var scrollIndicator: some View {
        let scrollIndex = self.scrollIndex ?? 0
        let isMiddle = scrollIndex > 0 && scrollIndex < items.count - 1
        
        HStack(spacing: 8) {
            Group {
                scrollIndicatorDot(scrollIndex == 0)
                
                scrollIndicatorDot(!isIncrease && isMiddle)
                
                scrollIndicatorDot(isIncrease && isMiddle)
            }
            .frame(width: 8, height: 8)
            
            scrollIndicatorDot(scrollIndex == items.count - 1)
                .frame(width: 6, height: 6)
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
