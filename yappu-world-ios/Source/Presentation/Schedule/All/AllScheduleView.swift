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
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                Text(convertYearMonth(text: viewModel.currentYearMonth))
                    .font(.pretendard18(.semibold))
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))
                    .padding(.top, 20)
                
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem()], spacing: 0) {
                            ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { index, item in
                                VStack {
                                    AllScheduleListView(datas: item.datas)
                                }
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .id(index)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $viewModel.scrollPosition)
                    .scrollTargetBehavior(.paging)
                    .scrollDisabled(viewModel.isLoading)
                    .scrollIndicators(.hidden)
                    .onChange(of: viewModel.scrollPosition) { oldPosition, newPosition in
                        print("Scroll position Change is Called \(newPosition)")
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
                    .onAppear { viewModel.scrollPosition = viewModel.lastVisibleIndex }
                }
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

extension AllScheduleView {
    private func convertYearMonth(text: String) -> String {
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.locale = Locale(identifier: "ko_KR")
        inputDateFormatter.dateFormat = "yyyy-MM"
        
        guard let date = inputDateFormatter.date(from: text) else { return "" }
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.locale = Locale(identifier: "ko_KR")
        outputDateFormatter.dateFormat = "yyyy년 MM월"
        
        let convertString = outputDateFormatter.string(from: date)
        return convertString
        
    }
}

#Preview {
    AllScheduleView()
}
