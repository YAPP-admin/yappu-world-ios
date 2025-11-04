//
//  YPToastMessageView.swift
//  yappu-world-ios
//
//  Created by 김건형 on 10/28/25.
//

import SwiftUI

struct YPToastMessageView: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Text(text)
                .font(.pretendard12(.semibold))
                .foregroundStyle(.yapp(.semantic(.static(.white))))
                .lineLimit(2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.yapp(.semantic(.label(.neutral))).opacity(0.88))
        )
        .shadow(radius: 10, y: 6)
    }
}

struct YPToastPresenter: ViewModifier {
    @Binding var isPresented: Bool
    let text: String
    var duration: TimeInterval = 1.6
    var bottomInset: CGFloat = 24

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content

            if isPresented {
                YPToastMessageView(text: text)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, bottomInset)
                    .onTapGesture {
                        withAnimation(.spring) { isPresented = false }
                    }
                    .task {
                        // 가벼운 성공 햅틱
                        let gen = UINotificationFeedbackGenerator()
                        gen.notificationOccurred(.success)

                        // 자동 닫힘
                        try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                        if isPresented {
                            withAnimation(.spring) { isPresented = false }
                        }
                    }
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: isPresented)
    }
}



#Preview {
    YPToastMessageView(text: "주소 복사가 완료됐어요!")
}
