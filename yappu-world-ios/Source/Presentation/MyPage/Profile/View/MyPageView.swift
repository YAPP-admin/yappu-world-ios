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
            HStack {
                NavigationTitle(text: "마이페이지")
                
                Spacer()
                
                SettingButton()
            }
            .padding(.horizontal, 20)
            
            MyPageProfileView(viewModel: viewModel)
                        
            Color.gray08
                .frame(height: 12)

            Spacer()
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
}


#Preview {
    MyPageView(viewModel: .init())
}
