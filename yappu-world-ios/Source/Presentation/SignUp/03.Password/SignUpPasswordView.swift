//
//  RegisterPasswordView.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/14/25.
//

import SwiftUI

struct SignUpPasswordView: View {
    @Bindable var viewModel: SignUpPasswordViewModel
    
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isConfirmPasswordFocused: Bool
    
    var body: some View {
        VStack {
            
            ScrollViewReader { reader in
                ScrollView {
                    VStack(spacing: 0) {
                        InformationLabel(customStep: 3, title: "비밀번호를 설정할게요.", sub: "영문+숫자+특수문자를 사용해, 8~20자 이내로\n설정해주세요.")
                            .padding(.top, 16)
                        
                        YPTextFieldView(textField: {
                            ZStack(alignment: .trailing) {
                                Group {
                                    
                                    SecureField("••••••••", text: $viewModel.password)
                                        .focused($isPasswordFocused)
                                        .opacity(viewModel.isPasswordSecure ? 1 : 0)
                                    
                                    TextField("••••••••", text: $viewModel.password)
                                        .focused($isPasswordFocused)
                                        .opacity(viewModel.isPasswordSecure.not() ? 1 : 0)
                                    
                                }
                                .textFieldStyle(.yapp(state: $viewModel.passwordState))
                                .textContentType(.password)
                                .onChange(of: viewModel.password) {
                                    viewModel.isValidPasswordCheck()
                                }
                                
                                Button(action: {
                                    let wasFocused = isPasswordFocused
                                    viewModel.isPasswordSecure.toggle()
                                    
                                    if wasFocused {
                                        isPasswordFocused = true
                                        viewModel.isValidPasswordCheck()
                                    }
                                    
                                }, label: {
                                    Image(viewModel.isPasswordSecure ? "Secure_ON" : "Secure_OFF")
                                })
                                .padding(.trailing, 20)
                                
                            }
                            
                            
                        }, state: $viewModel.passwordState, headerText: "비밀번호")
                        .padding(.top, 40)
                        
                        YPTextFieldView(textField: {
                            
                            ZStack(alignment: .trailing) {
                                
                                Group {
                                    SecureField("••••••••", text: $viewModel.confirmPassword)
                                        .focused($isConfirmPasswordFocused)
                                        .opacity(viewModel.isConfirmPasswordSecure ? 1 : 0)
                                    
                                    TextField("••••••••", text: $viewModel.confirmPassword)
                                        .focused($isConfirmPasswordFocused)
                                        .opacity(viewModel.isConfirmPasswordSecure.not() ? 1 : 0)
                                }
                                .textFieldStyle(.yapp(state: $viewModel.confirmPasswordState))
                                .textContentType(.password)
                                .onChange(of: viewModel.confirmPassword) {
                                    viewModel.isCheckSamePassword()
                                }
                                
                                
                                Button(action: {
                                    let wasFocused = isConfirmPasswordFocused
                                    viewModel.isConfirmPasswordSecure.toggle()
                                    
                                    if wasFocused {
                                        isConfirmPasswordFocused = true
                                        viewModel.isCheckSamePassword()
                                    }
                                }, label: {
                                    Image(viewModel.isConfirmPasswordSecure ? "Secure_ON" : "Secure_OFF")
                                    
                                })
                                .padding(.trailing, 20)
                                
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
            .disabled(viewModel.isValidPassword.not() || viewModel.isValidConfirmPassword.not())
        }
        .backButton(action: viewModel.clickBackButton)
        .onChange(of: isPasswordFocused) {
            if isPasswordFocused {
                viewModel.buttonState = .focus
            }
        }
        .onChange(of: isConfirmPasswordFocused) {
            if isConfirmPasswordFocused {
                viewModel.buttonState = .focus
            }
        }
        .onTapGesture {
            isPasswordFocused = false
            isConfirmPasswordFocused = false
            viewModel.buttonState = .default
        }
    }
}

#Preview {
    SignUpPasswordView(viewModel: .init(signUpInfo: .init()))
}
