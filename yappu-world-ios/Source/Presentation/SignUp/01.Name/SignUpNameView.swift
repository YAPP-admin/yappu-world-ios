//
//  RegisterNameView.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/14/25.
//

import SwiftUI

struct SignUpNameView: View {
    
    @Bindable var viewModel: SignUpNameViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    InformationLabel(customStep: 1, title: "만나서 반가워요 :)\n이름이 어떻게 되세요?", sub: "출석 확인을 위해 실명으로 입력해주세요.")
                        .padding(.top, 16)
                    
                    YPTextFieldView(textField: {
                        TextField("이름", text: $viewModel.name)
                            .textFieldStyle(.yapp(state: $viewModel.nameState))
                            .focused($isFocused)
                        
                        
                    }, state: $viewModel.nameState, headerText: "이름")
                    .padding(.top, 40)
                }
                .padding(.horizontal, 20)
            }
            
            Button(action: {
                viewModel.clickNextButton()
            }, label: {
                Text("다음")
                    .frame(maxWidth: .infinity)
            })
            .YPkeyboardAnimationButtonStyle(style: .primary, state: $viewModel.nameState)
            .disabled(viewModel.nameDisabled)
        }
        .backButton(title: "회원가입", action: viewModel.clickBackButton)
        .onTapGesture {
            withAnimation(.interactiveSpring) {
                viewModel.nameState = .default
                isFocused = false
            }
        }
        
    }
}

#Preview {
    SignUpNameView(viewModel: .init())
}
