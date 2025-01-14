//
//  RegisterEmailView.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/14/25.
//

import SwiftUI

struct RegisterEmailView: View {
    
    @Bindable var viewModel: RegisterMainViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    InformationLabel(customStep: 2, title: "이메일로 사용할\n이메일 정보를 알려주세요.")
                        .padding(.top, 16)
                    
                    YPTextFieldView(textField: {
                        TextField("이메일", text: $viewModel.email)
                            .textFieldStyle(.yapp(state: $viewModel.emailState))
                            .focused($isFocused)
                        
                    }, state: $viewModel.emailState, headerText: "이름")
                    .padding(.top, 40)
                }
                .padding(.horizontal, 20)
            }
            
            Button(action: {
                
            }, label: {
                Text("다음")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.yapp(radius: viewModel.emailState == .default ? 8 : 0, style: .primary ))
            .padding(.bottom, viewModel.emailState == .default ? 16 : 0)
            .padding(.horizontal, viewModel.emailState == .default ? 20 : 0)
            .disabled(viewModel.emailDisabled)
            .animation(.interactiveSpring, value: viewModel.emailState)
            
        }
        .onTapGesture {
            withAnimation(.interactiveSpring) {
                viewModel.emailState = .default
                isFocused = false
            }
        }
        
    }
}

#Preview {
    RegisterEmailView(viewModel: .init())
}
