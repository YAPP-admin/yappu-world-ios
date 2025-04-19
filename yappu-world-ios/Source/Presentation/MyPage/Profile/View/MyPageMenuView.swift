//
//  MyPageMenuView.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/16/25.
//

import SwiftUI

struct MyPageMenuView: View {
    
    @State
    var viewModel: MyPageViewModel
    
    enum SettingItem: String, CaseIterable {
        case 출석내역 = "출석 내역"
        case 이전활동내역 = "이전 활동 내역"
        case 이용문의
        case 회원탈퇴
    }
    
    var body: some View {
        menuSection()
            .padding(.horizontal, 20)
    }
}
// MARK: - Private UI Builders
private extension MyPageMenuView {
     func menuSection() -> some View {
        VStack(spacing: 0) {
            ForEach(SettingItem.allCases, id: \.self) { item in
                Button {
                    viewModel.clickMenuCell(item: item)
                } label: {
                    HStack {
                        Text(item.rawValue)
                            .font(.pretendard15(.medium))
                            .foregroundStyle(.yapp(.semantic(.label(.neutral))))
                        
                        Spacer()
                        
                        if item != .회원탈퇴 {
                            Image(.chevronRight)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.yapp(.semantic(.label(.disable))))
                        }
                    }
                }
                .padding(.vertical, 16)
            }
        }
    }
}

#Preview {
    MyPageMenuView(viewModel: MyPageViewModel())
}
