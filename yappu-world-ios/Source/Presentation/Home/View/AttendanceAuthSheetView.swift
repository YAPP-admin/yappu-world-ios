//
//  AttendanceAuthSheetView.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/22/25.
//

import SwiftUI

struct AttendanceAuthSheetView: View {
    
    @State
    var viewModel: HomeViewModel
    
    @FocusState
    private var focusedIndex: Int?
    
    var body: some View {
        VStack(spacing: 0) {
            Description()   // 제목 및 설명
            
            OTPField()      // 출석 코드 입력 박스
            
            AttendButton()  // 출석 버튼
            
            CloseButton()   // 닫기 버튼
        }
        .onAppear {
            focusedIndex = 0
        }
        .onChange(of: viewModel.otpField) { _, newValue in
            self.OTPCondition(value: newValue)
        }
        .background(.yellow)
    }
    
    //사용자 지정 OTP 필드 조건 및 텍스트 하나만 제한
    func OTPCondition(value: [String]) {
        let count = viewModel.otpField.count
        
        // 텍스트 1개이면, 다음 필드로 이동
        for index in 0..<count - 1 {
            if value[index].count == 1 && index == focusedIndex {
                focusedIndex = index + 1
            }
        }
        
        // 현재 필드가 비어 있고, 이전 필드가 비어 있지 않은 경우 뒤로 이동
        for index in 1...count - 1 {
            if value[index].isEmpty && !value[index - 1].isEmpty {
                focusedIndex = index - 1
            }
        }
        
        for index in 0..<count {
            if value[index].count > 1 {
                viewModel.otpField[index] = String(value[index].last!)
            }
        }
    }
}
// MARK: - Private UI Builders
private extension AttendanceAuthSheetView {
    
    func Description() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("오늘의 출석을 인증해주세요!")
                .font(.pretendard18(.semibold))
                .foregroundStyle(.labelGray)
            
            Text("출석 코드를 입력하면 오늘 출석이 완료돼요")
                .font(.pretendard14(.regular))
                .foregroundStyle(.gray88)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.red)
    }
    
    @ViewBuilder
    func OTPField() -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                ForEach(0..<viewModel.otpField.count, id: \.self) { index in
                    TextField("", text: $viewModel.otpField[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .frame(width: 48, height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(focusedIndex == index ? Color.yapp_primary : Color.gray52, lineWidth: 1)
                        )
                        .focused($focusedIndex, equals: index)
                }
            }
            
            // Error Description
            Group {
                switch viewModel.otpState {
                case .error:
                    Text("출석코드가 일치하지 않습니다. 다시 확인해주세요")
                        .font(.pretendard13(.regular))
                        .foregroundStyle(.yapp_primary)
                default: EmptyView()
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.otpState)
        }
        .padding(.top, 24)
    }
    
    func AttendButton() -> some View {
        Button(action: {
            // 출석 로직
        }) {
            Text("출석")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.yapp(font: .pretendard16(.semibold), radius: 10, style: .primary))
        .disabled(viewModel.checkStates())
        .padding(.top, 24)
    }
    
    func CloseButton() -> some View {
        Button(action: {
            viewModel.clickSheetToggle()
        }) {
            Text("닫기")
                .frame(maxWidth: .infinity)
        }
        .foregroundStyle(.yapp(.semantic(.primary(.normal))))
        .font(.pretendard14(.semibold))
        .padding(.vertical, 8)
        .padding(.top, 8)
    }
}

#Preview {
    AttendanceAuthSheetView(viewModel: HomeViewModel())
}
