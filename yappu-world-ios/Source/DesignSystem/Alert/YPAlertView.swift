//
//  YappAlertView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/19/25.
//

import SwiftUI

struct YPAlertView: View {
    @Binding
    private var isPresented: Bool
    
    private let title: String
    private let message: String?
    private let confirmTitle: String
    private let cancelTitle: String
    private let buttonAxis: Axis
    private let action: () -> Void
    
    init(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        confirmTitle: String,
        cancelTitle: String = "아니요!",
        buttonAxis: Axis = .horizontal,
        action: @escaping () -> Void
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.buttonAxis = buttonAxis
        self.cancelTitle = cancelTitle
        self.action = action
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            description
            
            buttons
        }
        .padding(16)
        .background(.yapp(.semantic(.background(.normal(.normal)))))
        .clipRectangle(20)
        .shadow(color: .black.opacity(0.3), radius: 18, x: 0, y: 4)
    }
    
    var description: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.pretendard18(.bold))
                .foregroundStyle(.yapp(.semantic(.label(.normal))))
            
            if let message {
                Text(message)
                    .font(.pretendard14(.regular))
                    .foregroundStyle(.yapp(.semantic(.label(.neutral))))
            }
        }
    }
    
    var buttons: some View {
        Group {
            switch buttonAxis {
            case .vertical:
                VStack(spacing: 8) {
                    
                    Button(action: action) {
                        Text(confirmTitle)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.yapp(style: .primary))
                    
                    Button(action: { isPresented = false }) {
                        Text(cancelTitle)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.yapp(style: .secondary))
                    
                }
            case .horizontal:
                HStack(spacing: 8) {
                    Button(action: { isPresented = false }) {
                        Text("아니요!")
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.yapp(style: .secondary))
                    
                    Button(action: action) {
                        Text(confirmTitle)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.yapp(style: .primary))
                }
            }
        }
    }
}

#Preview {
    YPAlertView(
        isPresented: .constant(true),
        title: "정말 탈퇴하시겠어요?",
        message: "탈퇴하시면 모든 정보가 삭제되요.",
        confirmTitle: "탈퇴하기",
        cancelTitle: "닫기",
        buttonAxis: .vertical,
        action: { }
    )
}
