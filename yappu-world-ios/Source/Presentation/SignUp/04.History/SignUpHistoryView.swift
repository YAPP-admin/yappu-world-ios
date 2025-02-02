//
//  SignUpHistoryView.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/27/25.
//

import SwiftUI

struct SignUpHistoryView: View {
    @Bindable var viewModel: SignUpHistoryViewModel
    @State private var overlayHeight: CGFloat = 0
    
    @FocusState private var isFocused: Bool
    
    let bottomID = "bottom" // 맨 아래를 식별하기 위한 ID
    
    var body: some View {
        
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        InformationLabel(customStep: 4, title: "\(viewModel.name)님!\n어떤역할로 활동중이신가요?",
                                         sub: "YAPP에서 활동중인 기수와 직군 정보를 알려주세요.\n이전 활동 내역이 있다면 함께 추가 할수 있어요.")
                        .padding(.top, 16)
                        .padding(.horizontal, 20)
                        
                        HistoryCell(history: $viewModel.currentHistory,
                                    overlayHeight: $overlayHeight) { delete in }
                        
                        if viewModel.history.count > 0 {
                            ForEach($viewModel.history, id: \.id, content: { $value in
                                HistoryCell(
                                    history: $value,
                                    overlayHeight: $overlayHeight
                                ) { delete in
                                    // 삭제
                                    viewModel.deleteHistory(value: delete)
                                }
                                .id(value.id)
                            })
                        }
                        
                        Button(action: {
                            viewModel.appendHistory()
                        }, label: {
                            HStack(spacing: 4) {
                                Image("plus_icon")
                                Text("이전 기수 활동 추가하기")
                                    .font(.pretendard14(.bold))
                                    .foregroundStyle(.gray60)
                            }
                        })
                        .zIndex(-9999)
                        .padding(.top, 20)
                    }
                    .padding(.bottom, overlayHeight) // 오버레이 높이만큼 패딩 추가
                    
                }
            }
            
            Button(action: {
                isFocused = false
                withAnimation(.smooth(duration: 0.2)) {
                    viewModel.clickSheetOpen()
                }
            }, label: {
                Text("다음")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.yapp(style: .primary))
            .padding(.bottom, 16)
            .padding(.horizontal, 20)
        }
        .backButton(action: viewModel.clickBackButton)
        .yappBottomPopup(isOpen: $viewModel.codeSheetOpen) {
            VStack(alignment: .leading) {
                Text("잠깐! 가입코드가 있다면, 입력해주세요.")
                    .font(.pretendard18(.bold))
                    .foregroundStyle(Color.labelGray)
                
                YPTextFieldView(textField: {
                    TextField("", text: $viewModel.signupCodeModel.code, prompt: Text("입력해주세요"))
                        .textFieldStyle(.yapp(state: $viewModel.signupCodeState))
                        .focused($isFocused)
                    
                }, state: $viewModel.signupCodeState, headerText: "가입코드")
                
                Button(action: {
                    viewModel.clickNextButton()
                }, label: {
                    Text("입력완료")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.yapp(style: .primary))
                .disabled(viewModel.signupCodeModel.code.isEmpty)
                
                Button(action: {
                    viewModel.clickNonCodeButton()
                }, label: {
                    Text("코드가 없어요")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.yapp_primary)
                        .font(.pretendard14(.semibold))
                })
                .padding(.top, 4)
            }
        }
        
        
    }
}

#Preview {
    SignUpHistoryView(viewModel: .init(signUpInfo: .init(
        email: "email@email.com",
        password: "abcabC!!",
        name: "인병윤"
    )))
}


// 높이를 추적하기 위한 PreferenceKey
struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
