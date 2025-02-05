//
//  SignUpCompleteView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/12/25.
//

import SwiftUI

struct SignUpCompleteView: View {
    @State
    var viewModel: SignUpCompleteViewModel
    
    init(viewModel: SignUpCompleteViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 80) {
            InformationLabel(
                title: title,
                sub: sub
            )
            
            image
            
            Spacer()
            
            completeButton
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .backButton(action: viewModel.clickBackButton)
    }
}

private extension SignUpCompleteView {
    var image: some View {
        let grayScale: CGFloat = viewModel.signupCompleteModel.signUpState == .standby ? 1 : 0
        
        return HStack {
            Spacer()
            
            Image(resource)
                .resizable()
                .grayscale(grayScale)
                .aspectRatio(contentMode: .fit)
                .frame(height: 131)
            
            Spacer()
        }
    }
    
    var completeButton: some View {
        VStack(spacing: 12) {
            if viewModel.signupCompleteModel.signUpState == .standby {
                Text("대기상태가 계속되고 있나요?")
                    .font(.pretendard16(.regular))
                    .foregroundStyle(.gray60)
            }
            
            Button(action: { viewModel.clickNextButton() }) {
                Text(buttonTitle)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.yapp(style: buttonStyle))
        }
    }
    
    var title: String {
        switch viewModel.signupCompleteModel.signUpState {
        case .complete: return "회원가입 완료!"
        case .standby: return "아직 가입 대기중이에요..."
        }
    }
    
    var sub: String {
        switch viewModel.signupCompleteModel.signUpState {
        case .complete: return "정상적으로 회원가입이 완료되었습니다.\n이제 즐거운 YAPP 즐길 준비 완료!!"
        case .standby: return "회원가입을 완료하려면 승인이 필요해요.\n운영진에게 승인을 요청해보세요."
        }
    }
    
    var resource: ImageResource {
        switch viewModel.signupCompleteModel.signUpState {
        case .complete: return .illustProfile
        case .standby: return .illustMemberHomeDisabled
        }
    }
    
    var buttonTitle: String {
        switch viewModel.signupCompleteModel.signUpState {
        case .complete: return "시작하기"
        case .standby: return "승인요청하기"
        }
    }
    
    var buttonStyle: ColorStyle {
        switch viewModel.signupCompleteModel.signUpState {
        case .complete: return .primary
        case .standby: return .border
        }
    }
}

#Preview {
    NavigationStack {
        SignUpCompleteView(viewModel: .init(signupCompleteModel: .init(signUpState: .complete)))
            .navigationBarTitleDisplayMode(.inline)
    }
}
