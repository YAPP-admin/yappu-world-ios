//
//  LoginView.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/4/25.
//

import SwiftUI

struct LoginView: View {
    
    @State var viewModel: LoginViewModel
    @FocusState var isFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                InformationLabel(title: "당신의 작은 아이디어가\n세상을 바꿉니다.")
                    .padding(.top, 72)
                
                ZStack(alignment: .topTrailing) {
                    
                    YPTextFieldView(
                        textField: {
                            TextField("", text: $viewModel.login.email, prompt: Text("\("YAPP@email.com")"))
                                .textFieldStyle(.yapp(state: $viewModel.emailState))
                                .focused($isFocused)
                        },
                        state: $viewModel.emailState,
                        headerText: "이메일",
                        isHeaderRequired: false,
                        headerPadding: 5
                    )
                    
                    Image("illust_card_no_BG")
                        .offset(x: -16, y: -54)
                }
                .padding(.top, 32)
                
                YPTextFieldView(
                    textField: {
                        SecureField("", text: $viewModel.login.password, prompt: Text("••••••••"))
                            .textFieldStyle(.yapp(state: $viewModel.passwordState))
                            .focused($isFocused)
                    },
                    state: $viewModel.passwordState,
                    headerText: "비밀번호",
                    isHeaderRequired: false,
                    headerPadding: 5
                )
                .padding(.top, 16)
                
                Button(action: { Task { await viewModel.clickLoginButton() } }) {
                    Text("로그인")
                        .frame(maxWidth: .infinity)
                }
                .disabled(viewModel.isValid.not())
                .buttonStyle(.yapp(style: .primary))
                .padding(.top, 24)

                HStack {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .foregroundStyle(Color.gray22)
                    
                    Text("또는")
                        .font(.pretendard14(.regular))
                        .foregroundStyle(Color.orGray)
                    
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .foregroundStyle(Color.gray22)
                }
                .padding(.vertical, 32)
                
                HStack(spacing: 10) {
                    Text("아직 회원이 아니신가요?")
                        .font(.pretendard14(.regular))
                        .foregroundStyle(Color.labelGray)
                    
                    Button(action: {
                        viewModel.clickRegisterButton()
                    }, label: {
                        Text("회원가입")
                            .font(.pretendard14(.semibold))
                            .foregroundStyle(Color.yapp_primary)
                    })
                }
            }
            .padding(.horizontal, 20)
        }
        .yappBottomPopup(isOpen: $viewModel.registerButtonOpen, view: {
            VStack(alignment: .leading, spacing: 0) {
                Text("서비스 이용약관")
                    .font(.pretendard18(.bold))
                    .foregroundStyle(Color.labelGray)
                    .padding(.bottom, 24)
                
                HStack {
                    
                    Button(action: {
                        viewModel.serviceBool.toggle()
                    }, label: {
                        checkButton(valid: viewModel.serviceBool, text: "서비스 이용약관에 동의")
                    })
                    
                    Spacer()
                    
                    Text("보기")
                        .font(.pretendard14(.semibold))
                        .foregroundStyle(Color.gray60)
                        .contentShape(Rectangle())
                        .padding(.all, 2)
                        .onTapGesture {
                            viewModel.clickTermsCellButton()
                        }
                }
                
                HStack {
                    
                    Button(action: {
                        viewModel.privacyBool.toggle()
                    }, label: {
                        checkButton(valid: viewModel.privacyBool, text: "개인정보 수집 및 이용 동의")
                    })
                    
                    Spacer()
                    
                    Text("보기")
                        .font(.pretendard14(.semibold))
                        .foregroundStyle(Color.gray60)
                        .contentShape(Rectangle())
                        .padding(.all, 2)
                        .onTapGesture {
                            viewModel.clickPrivacyPolicyButton()
                        }
                }
                
                Button(action: {
                    viewModel.marketingBool.toggle()
                }, label: {
                    checkButton(valid: viewModel.marketingBool, text: "광고 및 마케팅 수신 동의", isRequired: false)
                })
                .padding(.bottom, 24)
                
                Button(action: viewModel.clickPopupNextButton, label: {
                    Text("다음")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.yapp(style: .primary))
                .disabled(viewModel.registerIsValid.not())
                .animation(.smooth(duration: 0.2), value: viewModel.registerIsValid)
            }
        })
        .onTapGesture {
            isFocused = false
        }
    }
}

extension LoginView {
    func checkButton(valid: Bool, text: String, isRequired: Bool = true) -> some View {
        
        HStack {
            HStack(spacing: 0) {
                Image(valid ? "Check" : "Uncheck")
                
                Text(text)
                    .font(.pretendard15(.regular))
                    .foregroundStyle(valid ? Color.labelGray : Color.gray60)
                
                if isRequired {
                    Text(" (필수)")
                        .font(.pretendard15(.regular))
                        .foregroundStyle(Color.yapp_primary)
                } else {
                    Text(" (선택)")
                        .font(.pretendard15(.regular))
                        .foregroundStyle(valid ? Color.labelGray : Color.gray60)
                }
            }
        }
        
        .padding(.vertical, 4)
    }
}

#Preview {
    LoginView(viewModel: .init())
}
