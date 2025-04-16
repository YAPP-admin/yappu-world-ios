//
//  MyPageView.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import SwiftUI

struct MyPageView: View {
    @State
    var viewModel: MyPageViewModel
    
    var body: some View {
        VStack {
            HStack { // Navgation 영역
                NavigationTitle(text: "마이페이지")
                
                Spacer()
                
                SettingButton()
            }
            .padding(.horizontal, 20)
            
            MyPageProfileView(viewModel: viewModel)
                       
            // Divider
            Color.gray08
                .frame(height: 12)

            MyPageMenuView(viewModel: viewModel)
            
            Spacer()
            
            LogoutButton()
        }
        .yappDefaultPopup(
            isOpen: $viewModel.showWithdrawAlert,
            showBackground: false
        ) {
            YPAlertView(
                isPresented: $viewModel.showWithdrawAlert,
                title: "정말 탈퇴하시겠어요?",
                message: "탈퇴하시면 모든 정보가 삭제돼요.",
                confirmTitle: "탈퇴하기",
                action: { Task { await viewModel.clickWithdrawAlertConfirm() } }
            )
        }
        .yappDefaultPopup(
            isOpen: $viewModel.showLogoutAlert,
            showBackground: false
        ) {
            YPAlertView(
                isPresented: $viewModel.showLogoutAlert,
                title: "로그아웃 할까요?",
                confirmTitle: "로그아웃",
                action: { Task { await viewModel.clickLogoutAlertConfirm() } }
            )
        }
    }
}
// MARK: - Private UI Builders
extension MyPageView {
    
    private func NavigationTitle(text: String) -> some View {
        Text(text)
            .font(.pretendard20(.bold))
            .foregroundStyle(Color.labelGray)
            .lineLimit(1)
    }
    
    private func SettingButton() -> some View {
        Button(action: {
            viewModel.clickSetting()
        }, label: {
            Image("setting_icon")
        })
    }
    
    private func LogoutButton() -> some View {
        Button(action: viewModel.clickLogoutButton) {
            Text("로그아웃")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.yapp(style: .secondary))
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}


#Preview {
    MyPageView(viewModel: .init())
}
