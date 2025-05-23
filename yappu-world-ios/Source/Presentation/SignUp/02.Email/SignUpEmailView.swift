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
                        HStack {
                            TextField("이메일", text: $viewModel.emailTypingText)
                                .focused($isFocused)
                                .onChange(of: viewModel.emailTypingText, {
                                    viewModel.textChanged()
                                })
                        }
                        .textFieldStyle(.yapp(state: $viewModel.emailState, usingTextFieldStatus: true))
                        
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
        .backButton(title: "회원가입", action: viewModel.clickBackButton)
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
