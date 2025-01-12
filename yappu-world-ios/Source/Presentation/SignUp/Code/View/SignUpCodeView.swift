//
//  CodeView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/12/25.
//

import SwiftUI

struct SignUpCodeView: View {
    @Bindable
    private var viewModel: SignUpCodeViewModel
    
    @FocusState
    private var focusedField: TextFieldType?
    
    init(viewModel: SignUpCodeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            InformationLabel(
                customStep: 5,
                title: "가입코드만 입력하면 끝",
                sub: "YAPP 신청시 전달받은 가입코드를 입력해주세요."
            )
            
            codeTextFields
                .padding(.top, 40)
            
            helpButton
                .padding(.top, 40)
            
            Spacer()
            
            Button(action: viewModel.clickNextButton) {
                Text("다음")
                    .frame(maxWidth: .infinity)
            }
            .disabled(viewModel.model.isValid.not())
            .buttonStyle(.yapp(radius: 12, style: .primary))
            .animation(.easeInOut, value: viewModel.model.isValid.not())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .navigationTitle("회원가입")
    }
}

private extension SignUpCodeView {
    var codeTextFields: some View {
        HStack(spacing: 16) {
            Spacer()
            
            codeTextField(
                $viewModel.model.code1,
                type: .code1,
                next: .code2
            )
            
            codeTextField(
                $viewModel.model.code2,
                type: .code2,
                next: .code3
            )
            
            codeTextField(
                $viewModel.model.code3,
                type: .code3,
                next: .code4
            )
            
            codeTextField(
                $viewModel.model.code4,
                type: .code4
            )
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func codeTextField(
        _ code: Binding<String>,
        type: TextFieldType,
        next: TextFieldType? = nil
    ) -> some View {
        TextField("", text: code)
            .font(.pretendard24(.bold))
            .foregroundStyle(.labelGray)
            .tint(.yapp_primary)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .padding(8)
            .frame(width: 48, height: 48)
            .background(.gray22)
            .clipRectangle(10)
            .focused($focusedField, equals: type)
            .onChange(of: code.wrappedValue) { oldValue, newValue in
                guard
                    oldValue.isEmpty && newValue.isEmpty.not(),
                    next != nil
                else {
                    return
                }
                focusedField = next
            }
    }
    
    var helpButton: some View {
        Button(action: {}) {
            HStack(spacing: 4) {
                Image(.circleQuestion)
                    .resizable()
                    .frame(width: 16, height: 16)
                
                Text("가입코드를 모르겠어요.")
                    .font(.pretendard14(.bold))
            }
            .foregroundStyle(.gray60)
        }
    }
}

private extension SignUpCodeView {
    enum TextFieldType: Hashable {
        case code1
        case code2
        case code3
        case code4
    }
}

#Preview {
    NavigationStack {
        SignUpCodeView(viewModel: .init(model: .init()))
            .navigationBarTitleDisplayMode(.inline)
    }
}
