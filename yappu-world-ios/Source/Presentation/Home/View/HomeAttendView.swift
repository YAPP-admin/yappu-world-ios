//
//  HomeAttendView.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/16/25.
//

import SwiftUI

struct HomeAttendView: View {
    
    @State
    var viewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            NoticeBanner(text: "세션 당일이예요! 활기찬 하루 되세요:)")
            AttendanceCard()
        } // VStack
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .background(Color.yellow) // 임시
    }
}
// MARK: - Private UI Builders
private extension HomeAttendView {
    
    func NoticeBanner(text: String) -> some View {
        HStack(spacing: 4) {
            Image("loudSpeaker")
            Text(text)
                .font(.pretendard12(.medium))
                .foregroundStyle(.labelGray)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(Color.activetyCellBackgroundColor)
        .cornerRadius(10)
    }
    
    func AttendanceCard() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // 세션 제목
            Text("2차 데모데이")
                .font(.pretendard13(.medium))
                .foregroundStyle(.labelGray)
            
            // 시간 정보
            HStack {
                HStack(spacing: 4) {
                    Image("clock")

                    Text("오후 6시 오픈")
                        .font(.pretendard14(.medium))
                        .foregroundStyle(.yapp_primary)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("현재시각")
                        .font(.pretendard13(.medium))
                        .foregroundStyle(.gray60)
                    
                    Text("09:00:31")
                        .font(.pretendard13(.semibold))
                        .foregroundStyle(.labelGray)
                }
                
                // 출석 버튼
//                Button(action: {
//                    Task { await viewModel.clickNextButton() }
//                }) {
//                    Text("출석하기")
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 12)
//                        .background(viewModel.isAttendDisabled ? Color.yapp(.semantic(.primary(.normal))) : Color.gray.opacity(0.1))
//                        .foregroundStyle(isCheckinEnabled ? .white : .gray)
//                        .font(.pretendard15(.semibold))
//                        .cornerRadius(8)
//                }
//                .YPkeyboardAnimationButtonStyle(style: .primary, state: $viewModel.emailState)
//                .disabled(viewModel.isAttendDisabled)
            }
            .padding(.top, 10)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                .foregroundColor(Color.yapp(.semantic(.primary(.normal))))
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    HomeAttendView(viewModel: HomeViewModel())
}
