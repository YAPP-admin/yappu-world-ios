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
            
            TabView(selection: $viewModel.scrollPosition) {
                ForEach(viewModel.items) { item in
                    scheduleList(item: item)
                        .overlay {
                            let isLoading = viewModel.isLoading[item.yearMonth]
                            if isLoading ?? true { ProgressView() }
                        }
                        .tag(item.yearMonth)
                        .onAppear { viewModel.onPageAppear(item.yearMonth) }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: viewModel.scrollPosition)
        }
    }
}

// MARK: - Configure Views
private extension AllScheduleView {
    @ViewBuilder
    func scheduleList(item: AllScheduleModel) -> some View {
        if item.isEmpty {
            VStack(spacing: 32) {
                Image(.errorYappu)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 231, height: 166)

                Text("등록된 일정이 없어요!")
                    .font(.pretendard14(.regular))
                    .foregroundStyle(.yapp(.semantic(.label(.alternative))))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let datas = item.datas {
            AllScheduleListView(datas: datas, viewModel: viewModel)
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
