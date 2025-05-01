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
                                    if let datas = item.datas {
                                        AllScheduleListView(datas: datas)
                                    }
                                }
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .id(index)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $viewModel.scrollPosition)
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(.hidden)
                    .onChange(of: viewModel.scrollPosition) { oldValue, newValue in
                        // 스크롤 위치가 변경될 때마다 타이머를 재설정
                        viewModel.scrollTimer?.cancel()
                        viewModel.scrollTimer = Task {
                            do {
                                try await Task.sleep(nanoseconds: 200_000_000)
                                guard let id = viewModel.scrollPosition else { return }
                                // 스크롤이 멈추면 데이터 로드
                                try await viewModel.onChangeTask(id: id)
                                print("스크롤 종료 감지, 위치:", id)
                            } catch {
                                // 타이머가 취소되면 아무것도 하지 않음
                            }
                        }
                    }
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
