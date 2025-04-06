//
//  RegisterPasswordView.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/14/25.
//

import SwiftUI

struct SignUpPasswordView: View {
    @Bindable var viewModel: SignUpPasswordViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            
            ScrollViewReader { reader in
                ScrollView {
                    VStack(spacing: 0) {
                        InformationLabel(customStep: 3, title: "비밀번호를 설정할게요.", sub: "영문+숫자+특수문자를 사용해, 8~20자 이내로\n설정해주세요.")
                            .padding(.top, 16)
                        
                        YPTextFieldView(textField: {
                            SecureField("••••••••", text: $viewModel.password)
                                .textFieldStyle(.yapp(state: $viewModel.passwordState))
                                .focused($isFocused)
                                .textContentType(.password)
                                .onChange(of: viewModel.password) {
                                    viewModel.isValidPasswordCheck()
                                }
                            
                        }, state: $viewModel.passwordState, headerText: "비밀번호")
                        .padding(.top, 40)
                        
                        YPTextFieldView(textField: {
                            SecureField("••••••••", text: $viewModel.confirmPassword)
                                .textFieldStyle(.yapp(state: $viewModel.confirmPasswordState))
                                .focused($isFocused)
                                .textContentType(.password)
                                .onChange(of: viewModel.confirmPassword) {
                                    viewModel.isCheckSamePassword()
                                }
                            
                        }, state: $viewModel.confirmPasswordState, headerText: "비밀번호 확인")
                        .padding(.top, 20)
                        
                        Spacer()
                            .frame(height: 60)
                            .id("bottom")
                    }
                    .padding(.horizontal, 20)
                    .onChange(of: viewModel.confirmPasswordState) {
                        Task {
                            try await Task.sleep(for: .milliseconds(300))
                            await MainActor.run {
                                if viewModel.confirmPasswordState == .focus {
                                    withAnimation {
                                        reader.scrollTo("bottom", anchor: .top)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            Button(action: {
                viewModel.clickNextButton()
            }, label: {
                Text("다음")
                    .frame(maxWidth: .infinity)
            })
            .YPkeyboardAnimationButtonStyle(style: .primary, state: $viewModel.buttonState)
            .disabled(viewModel.isValidPassword.not() && viewModel.isValidConfirmPassword.not())
        }
        .backButton(action: viewModel.clickBackButton)
        .onChange(of: isFocused) {
            viewModel.buttonStateCheck(value: isFocused)
        }
        .onTapGesture {
            withAnimation(.interactiveSpring) {
                isFocused = false
            }
        }
    }
}

#Preview {
    SignUpPasswordView(viewModel: .init(signUpInfo: .init()))
}
