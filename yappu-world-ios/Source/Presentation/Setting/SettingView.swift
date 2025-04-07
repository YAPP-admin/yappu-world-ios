//
//  SettingView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/13/25.
//

import SwiftUI

struct SettingView: View {
    @State
    private var viewModel: SettingViewModel
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            title
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            
            list
                .padding(.horizontal, 20)
                .padding(.top, 16)
            
            Spacer()
            
            Button(action: viewModel.clickLogoutButton) {
                Text("로그아웃")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.yapp(style: .border))
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .backButton(action: viewModel.clickBackButton)
        .background(.yapp(.semantic(.background(.normal(.normal)))))
        .task { await viewModel.onTask() }
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

private extension SettingView {
    var title: some View {
        Text("설정")
            .font(.pretendard24(.bold))
            .foregroundStyle(.yapp(.semantic(.label(.normal))))
    }
    
    var list: some View {
        VStack(spacing: 0) {
            ForEach(SettingItem.allCases, id: \.self) { item in
                cell(item: item) {
                    switch item {
                    case .회원탈퇴:
                        viewModel.clickWithdrawCell()
                    case .이용문의:
                        viewModel.clickContactUsCell()
                    default: break
                    }
                }
                .padding(.vertical, 16)
                
                if item == .이용약관 {
                    termsSection
                }
                
                if SettingItem.allCases.last != item {
                    divider
                }
            }
        }
    }
    
    func cell(
        item: SettingItem,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                Text(item.rawValue)
                    .font(.pretendard18(.bold))
                    .foregroundStyle(.yapp(.semantic(.label(.neutral))))
                
                Spacer()
                
                if item == .알림 {
                    alertToggle
                }
                
                if item == .이용문의 {
                    chevronRightImage
                }
            }
        }
    }
    
    func subCell(
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.pretendard16(.medium))
                    .foregroundStyle(.yapp(.semantic(.label(.neutral))))
                
                Spacer()
                
                chevronRightImage
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
        }
    }
    
    var termsSection: some View {
        VStack(spacing: 0) {
            ForEach(SubSettingItem.allCases, id: \.self) { subItem in
                subCell(title: subItem.rawValue) {
                    switch subItem {
                    case .개인정보_처리방침:
                        viewModel.clickPrivacyPolicyCell()
                    case .이용약관:
                        viewModel.clickTermsCell()
                    }
                }
                
                if SubSettingItem.allCases.last != subItem {
                    divider
                }
            }
        }
    }
    
    var alertToggle: some View {
        YPSwitch(isOn: $viewModel.isMasterEnabled,
                 action: {
            await viewModel.bindingAlertToggle()
        })
    }
    
    var chevronRightImage: some View {
        Image(.chevronRight)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
            .foregroundStyle(.yapp(.semantic(.label(.assistive))))
    }
    
    var divider: some View {
        Rectangle()
            .fill(.yapp(.semantic(.line(.alternative))))
            .frame(height: 1)
    }
}

private extension SettingView {
    enum SettingItem: String, CaseIterable {
        case 알림
        case 이용약관
        case 이용문의
        case 회원탈퇴
    }
    
    enum SubSettingItem: String, CaseIterable {
        case 개인정보_처리방침 = "개인정보 처리방침"
        case 이용약관
    }
}

#Preview {
    SettingView(viewModel: .init())
}
