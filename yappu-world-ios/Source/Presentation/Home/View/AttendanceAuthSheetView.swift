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
    private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Description()       // 제목 및 설명
            
            VStack(spacing: 8) {
                VerificationField() // 출석 코드 입력 박스
                
                ErrorDescription()
            }
            
            HStack(spacing: 8) {
                CloseButton()       // 닫기 버튼
                
                AttendButton()      // 출석 버튼
            }
        }
        .onChange(of: viewModel.otpState) { old, new in
            if case .error(_) = new {
                // 에러 상태로 변경되면 햅틱 발생
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
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
            
            Text("4자리 코드를 입력하면 오늘 출석이 완료돼요")
                .font(.pretendard14(.regular))
                .foregroundStyle(.gray88)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func AttendButton() -> some View {
        Button(action: { Task { await viewModel.verifyOTP() } }) {
            Text("출석")
                .frame(maxWidth: .infinity)
        }
        .font(.pretendard16(.bold))
        .buttonStyle(.yapp(radius: 12, style: .primary))
        .disabled(viewModel.otpText.count != viewModel.otpCount)
    }
    
    func CloseButton() -> some View {
        Button("닫기", action: viewModel.reset)
            .font(.pretendard16(.bold))
            .foregroundStyle(.yapp(.semantic(.primary(.normal))))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(.yapp(.semantic(.line(.normal))), lineWidth: 1)
            }
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
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .compositingGroup()
        .phaseAnimator([0, 10, -10, 10, -5, 5, 0], trigger: viewModel.isInvalid) { content, offset in
            content
                .offset(x: offset)
        } animation: { _ in
                .linear(duration: 0.06)
        }
        .background {
            TextField("", text: $viewModel.otpText)
                .focused($isFocused)
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
            isFocused = true
        }
        .onChange(of: viewModel.otpText) { oldValue, newValue in
            viewModel.otpText = String(newValue.prefix(viewModel.otpCount))
            
            if viewModel.otpText.count <= viewModel.otpCount {
                viewModel.otpState = .typing
            }
        }
    }
    
    @ViewBuilder
    func ErrorDescription() -> some View {
        VStack {
            switch viewModel.otpState {
            case let .error(message):
                Text(message)
                    .font(.pretendard13(.regular))
                    .foregroundStyle(.yapp_primary)
            default: EmptyView()
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.isInvalid)
    }
    
    /// Individual Character View
    func CharacterView(_ index: Int) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(borderColor(index), lineWidth: 1)
            .frame(width: 48, height: 48)
            .overlay {
                /// Character
                let stringValue = string(index)
                if stringValue != "" {
                    Text(stringValue)
                        .font(.pretendard16(.regular))
                        .transition(.blurReplace)
                        .foregroundStyle(viewModel.otpState != .typing ? .yapp_primary : .labelGray)
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
            viewModel.otpText.count == index && isFocused ? .yapp_primary : .gray52
        case .error:
            .yapp_primary
        default: .clear
        }
    }
}

#Preview {
    AttendanceAuthSheetView(viewModel: HomeViewModel())
}
