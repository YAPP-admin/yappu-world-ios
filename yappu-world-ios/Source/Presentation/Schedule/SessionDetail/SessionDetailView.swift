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
            VStack(alignment: viewModel.sessionEntity == nil ? .center : .leading, spacing: 24) {
                HStack { Spacer() }
                if let session = viewModel.sessionEntity {
                    sessionTopView(session: session)
                    
                    sessionBottomView(session: session)
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
        })
        .backButton(title: "세션 상세", action: viewModel.clickBackButton)
    }
}
//MARK: - SessionDetailView Extesions
extension SessionDetailView {
    func sessionTopView(session: SessionDetailEntity) -> some View {
        let phase = session.progressPhase
        
        return VStack(alignment: .leading, spacing: 16) {
            // Bedge
            Text(phase.title)
                .font(.pretendard13(.medium))
                .foregroundStyle(.common100)
                .frame(width: 43, height: 24)
                .padding(.vertical, 1.5)
                .padding(.horizontal, 3)
                .background(phase.color)
                .clipRectangle(8)
            
            // Title
            Text(session.title)
                .font(.pretendard28(.semibold))
                .foregroundStyle(.yapp(.semantic(.label(.normal))))
            
            // Info
            VStack(spacing: 8) {
                // 시간
                HStack(spacing: 8) {
                    Image(.history)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.accentCoolNatural)
                    
                    //                    if let date = session.startDate.toDateFormat(as: "yyyy. MM. dd (EEEEE)"), let time = session.tim.toTimeFormat(as: "aa h시 - aa h시") {
                    //                        Text("\(date) / \(time)")
                    //                            .font(.pretendard14(.regular))
                    //                    }
                    Spacer()
                } // HStack
                
                // 위치
                HStack(alignment: .top, spacing: 8) {
                    Image(.location)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.accentCoolNatural)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.place ?? "")
                            .font(.pretendard14(.regular))
                            .foregroundStyle(.yapp(.semantic(.label(.normal))))
                        
                        Text(session.address ?? "")
                            .font(.pretendard12(.regular))
                            .foregroundStyle(.yapp(.semantic(.label(.assistive))))
                    } // VStack
                    
                    Spacer()
                } // HStack
            } // VStack
        }
        .padding(.horizontal, 20)
    }
    
    func sessionBottomView(session: SessionDetailEntity) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            YPSection(sections: viewModel.sections, isSelected: $viewModel.isSelected, tintColor: Color.yapp(.semantic(.primary(.normal))))
            
            TabView(selection: $viewModel.isSelected) {
//                AllScheduleView()
//                    .tag(YPSectionType.all)
//                    .padding(.top, 20)
//                
//                SessionScheduleView()
//                    .tag(YPSectionType.session)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .transition(.slide)
            .ignoresSafeArea(edges: [.top, .bottom])
        }
    }
}

#Preview {
    SessionDetailView(viewModel: .init(id: ""))
}
