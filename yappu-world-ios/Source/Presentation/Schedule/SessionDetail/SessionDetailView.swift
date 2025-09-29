//
//  SessionDetailView.swift
//  yappu-world-ios
//
//  Created by 김건형 on 9/26/25.
//

import SwiftUI
import MarkdownUI

struct SessionDetailView: View {
    
    @State
    var viewModel: SessionDetailViewModel
    
    var body: some View {
        YPScrollView(axis: .vertical,
                     showsIndicators: true,
                     ignoreSafeArea: [],
                     content: {
            VStack(alignment: viewModel.scheduleEntity == nil ? .center : .leading, spacing: 9) {
                HStack { Spacer() }
                if let schedule = viewModel.scheduleEntity {
                    sessionTitleView(schedule: schedule)
                    
                } else {
                    InformationLabel(title: "앗! 오류가 발생했어요", titleFont: .pretendard24(.bold))
                    Image("errorYappu")
                        .padding(.top, 200)
                    Text("예상하지 못한 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.")
                        .multilineTextAlignment(.center)
                        .font(.pretendard14(.regular))
                        .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                        .padding(.top, 23)
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 45)
            .padding(.horizontal, 20)
        })
        .backButton(title: "세션 상세", action: viewModel.clickBackButton)
        .task {
            do {
                //                try await viewModel.onTask()
            } catch {
                //                await viewModel.errorAction()
            }
        }
    }
}
//MARK: - SessionDetailView Extesions
extension SessionDetailView {
    func sessionTitleView(schedule: ScheduleEntity) -> some View {
        var phase = schedule.scheduleProgressPhase ?? .pending
        if phase == .done && schedule.relativeDays ?? 0 < 0 {
            phase = .pending
        }
        
        return VStack(alignment: .leading, spacing: 16) {
            // Bedge
            Text(phase.title)
                .font(.pretendard13(.medium))
                .foregroundStyle(.common100)
                .frame(width: 43, height: 24)
                .padding(.vertical, 1.5)
                .padding(.horizontal, 5)
                .background(phase.color)
                .clipRectangle(8)
            
            Text(schedule.name)
                .font(.pretendard28(.semibold))
                .foregroundStyle(.yapp(.semantic(.label(.normal))))
            
            VStack(spacing: 8) {
                // 시간
                HStack(spacing: 8) {
                    Image(.history)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                    
                    if let date = schedule.date?.toDateFormat(as: "yyyy. MM. dd (EEEEE)"), let time = schedule.time?.toTimeFormat(as: "aa h시 - aa h시") {
                        Text("\(date) / \(time)")
                            .font(.pretendard14(.regular))
                    }
                }
                
                // 위치
                HStack(spacing: 8) {
                    Image(.location)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                    
                    if let date = schedule.date?.toDateFormat(as: "yyyy. MM. dd (EEEEE)"), let time = schedule.time?.toTimeFormat(as: "aa h시 - aa h시") {
                        Text("\(date) / \(time)")
                            .font(.pretendard14(.regular))
                    }
                }
            }
        }
    }
    
    //    func content(schedule: ScheduleEntity) -> some View {
    //        Markdown {
    //            schedule
    //        }
    //        .font(.pretendard15(.regular))
    //        .foregroundStyle(.labelGray)
    //    }
    
    // 아이콘 이미지와 텍스트를 가로로 배열 하는 View
    func sessionInfoCell(image: ImageResource, content: String) -> some View {
        HStack(spacing: 8) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
            
            Text(content)
                .font(.pretendard12(.regular))
        }
        .foregroundStyle(.yapp(.semantic(.interaction(.inactive))))
    }
}

#Preview {
    SessionDetailView(viewModel: .init(id: ""))
}
