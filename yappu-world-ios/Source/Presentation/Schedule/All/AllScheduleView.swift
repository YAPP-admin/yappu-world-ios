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
                HStack {
                    Button(action: {
                        viewModel.previousButtonAction()
                    }, label: {
                        Image("previousButton")
                    })
                    
                    Text(convertYearMonth(text: viewModel.currentYearMonth))
                        .font(.pretendard18(.semibold))
                        .foregroundStyle(.yapp(.semantic(.label(.normal))))
                    
                    Button(action: {
                        viewModel.nextButtonAction()
                    }, label: {
                        Image("nextButton")
                    })
                    
                    Spacer()
                }
                .padding(.leading, 20)
                
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem()], spacing: 0) {
                            ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { index, item in
                                
                                ZStack {
                                    VStack {
                                        if let datas = item.datas, item.isEmpty.not() {
                                            AllScheduleListView(datas: datas)
                                        } else if item.isEmpty {
                                            Text("예정된 세션이 없어요.")
                                                .font(.pretendard13(.regular))
                                                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                                                .padding(.top, 150)
                                        }
                                    }
                                    
                                    if viewModel.isLoading {
                                        ProgressView()
                                    }
                                }
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .id(index)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $viewModel.scrollPosition)
                    .transition(.slide)
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(.hidden)
                    .onChange(of: viewModel.scrollPosition) {
                        Task { try await viewModel.onChangeTask() }
                    }
                    .task { await viewModel.onTask() }
                }
            }
        }
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
