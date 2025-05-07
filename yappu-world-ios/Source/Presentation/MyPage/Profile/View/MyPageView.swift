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
                YPNavigationTitleView(text: "마이페이지")
                
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
        .task {
            do {
                try await viewModel.onTask()
            } catch {
                await viewModel.errorAction()
            }
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
