//
//  AllScheduleView.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/19/25.
//

import SwiftUI

struct AllScheduleView: View {
    
    @State var viewModel: AllScheduleViewModel = .init()
    @State var dragOffset: CGFloat = 0
    @State var isDragging = false
    @State private var scrollPosition: Int?
    
    // For screen width detection
    @Environment(\.displayScale) private var displayScale
    
    var body: some View {
        
        ZStack {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem()], spacing: 0) {
                        ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { index, item in
                            Text(item.yearMonth)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .id(index)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $scrollPosition)
                .scrollTargetBehavior(.paging)
                .scrollDisabled(viewModel.isLoading)
                .scrollIndicators(.hidden)
                .onChange(of: scrollPosition) { oldPosition, newPosition in
                    if let newIndex = newPosition {
                        viewModel.updateVisibleIndex(newIndex)
                        viewModel.checkForAdditionDataLoad(newIndex)
                    }
                }
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { gesture in
                            if isDragging.not() {
                                isDragging = true
                                viewModel.updateScrollState(isScrolling: true)
                            }
                            dragOffset = gesture.translation.width
                        }
                        .onEnded { _ in
                            isDragging = false
                            dragOffset = 0
                            viewModel.updateScrollState(isScrolling: false)
                        }
                )
                .onAppear { scrollPosition = viewModel.lastVisibleIndex }
            }

            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .frame(width: 100, height: 100)
            }
        }
        .task { await viewModel.onTask() }
    }
    
    
}

#Preview {
    AllScheduleView()
}
