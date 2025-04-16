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
        VStack {
            NoticeBanner(text: "세션 당일이예요! 활기찬 하루 되세요:)")
        } // VStack
        .padding(.horizontal, 20)
        .padding(.top, 24)
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
}

#Preview {
    HomeAttendView(viewModel: HomeViewModel())
}
