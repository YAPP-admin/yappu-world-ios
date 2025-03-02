//
//  RegisterEmailView.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/14/25.
//

import SwiftUI

struct SignUpEmailView: View {
    
    @Bindable var viewModel: SignUpEmailViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    InformationLabel(customStep: 2, title: "이메일로 사용할\n이메일 정보를 알려주세요.")
                        .padding(.top, 16)
                    
                    YPTextFieldView(textField: {
                        TextField("이메일", text: $viewModel.email)
                            .textFieldStyle(.yapp(state: $viewModel.emailState))
                            .focused($isFocused)
                        
                    }, state: $viewModel.emailState, headerText: "이메일")
                    .padding(.top, 40)
                }
                .padding(.horizontal, 20)
            }
            
            Button(action: {
                Task { await viewModel.clickNextButton() }
            }, label: {
                Text("다음")
                    .frame(maxWidth: .infinity)
            })
            .YPkeyboardAnimationButtonStyle(style: .primary, state: $viewModel.emailState)
            .disabled(viewModel.emailDisabled)
            
        }
        .backButton(action: viewModel.clickBackButton)
        .onTapGesture {
            withAnimation(.interactiveSpring) {
                viewModel.emailState = .default
                isFocused = false
            }
        }
        
    }
}

#Preview {
    SignUpEmailView(viewModel: .init(signUpInfo: .init()))
}
