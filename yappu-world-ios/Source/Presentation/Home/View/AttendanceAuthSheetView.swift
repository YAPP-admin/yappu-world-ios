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
    private var isActive: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Description()       // 제목 및 설명
            
            VStack(spacing: 8) {
                VerificationField() // 출석 코드 입력 박스
                
                ErrorDescription()
            }
            
            AttendButton()      // 출석 버튼
            
            CloseButton()       // 닫기 버튼
        }
        .onAppear {
            isActive = true
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
    }
    
    func AttendButton() -> some View {
        Button(action: {
            // 출석 로직
            viewModel.otpState = .error("")
            viewModel.isInvalid.toggle()
        }) {
            Text("출석")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.yapp(font: .pretendard16(.semibold), radius: 10, style: .primary))
        .disabled(viewModel.otpText.count != viewModel.otpCount)
        .padding(.top, 24)
    }
    
    func CloseButton() -> some View {
        Button(action: {
            viewModel.clickSheetToggle()
            viewModel.otpText = ""
            viewModel.otpState = .typing
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
// MARK: - VerificationField 관련 함수
extension AttendanceAuthSheetView {
    
    func VerificationField() -> some View {
        HStack(spacing: 8) {
            ForEach(0..<4, id: \.self) { index in
                CharacterView(index)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.otpText)
        .animation(.easeInOut(duration: 0.2), value: isActive)
        .compositingGroup()
        .phaseAnimator([0, 10, -10, 10, -5, 5, 0], trigger: viewModel.isInvalid) { content, offset in
            content
                .offset(x: offset)
        } animation: { _ in
                .linear(duration: 0.06)
        }
        .padding(.top, 24)
        .background {
            TextField("", text: $viewModel.otpText)
                .focused($isActive)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .mask(alignment: .trailing) {
                    Rectangle()
                        .frame(width: 1, height: 1)
                        .opacity(0.01)
                }
                .allowsTightening(false)
        }
        .contentShape(.rect)
        .onTapGesture {
            isActive = true
        }
        .onChange(of: viewModel.otpText) { oldValue, newValue in
            viewModel.otpText = String(newValue.prefix(viewModel.otpCount))
            
            if viewModel.otpText.count <= viewModel.otpCount {
                viewModel.otpState = .typing
            } else {
                viewModel.otpState = .error("")
                viewModel.isInvalid.toggle()
            }
        }
    }
    
    @ViewBuilder
    func ErrorDescription() -> some View {
        VStack {
            switch viewModel.otpState {
            case .error:
                Text("출석코드가 일치하지 않습니다. 다시 확인해주세요")
                    .font(.pretendard13(.regular))
                    .foregroundStyle(.yapp_primary)
            default: EmptyView()
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.isInvalid)
    }
    
    /// Individual Character View
    @ViewBuilder
    func CharacterView(_ index: Int) -> some View {
        Group {
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor(index), lineWidth: 1)
        }
        .frame(width: 48, height: 48)
        .overlay {
            /// Character
            let stringValue = string(index)
            if stringValue != "" {
                Text(stringValue)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .transition(.blurReplace)
            }
        }
    }
    
    func string(_ index: Int) -> String {
        if viewModel.otpText.count > index {
            let startIndex = viewModel.otpText.startIndex
            let stringIndex = viewModel.otpText.index(startIndex, offsetBy: index)
            return String(viewModel.otpText[stringIndex])
        }
        return ""
    }

    func borderColor(_ index: Int) -> Color {
        switch viewModel.otpState {
        case .typing:
            viewModel.otpText.count == index && isActive ? .yapp_primary : .gray52
        case .error:
            .yapp_primary
        default: .clear
        }
    }
}

#Preview {
    AttendanceAuthSheetView(viewModel: HomeViewModel())
}
