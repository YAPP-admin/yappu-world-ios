//
//  YPTextField.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/6/25.
//

import SwiftUI

/// Header, TextField, Footer로 구성되어있는 View입니다. Footer는 Message 타입으로 error, information 등의 정보를 나타냅니다.
public struct YPTextFieldView<TextField: View>: View {
    @ViewBuilder private let textField: TextField
    @Binding private var state: InputState

    /// header 관련 속성
    private let headerText: String?
    private let isHeaderRequired: Bool
    private let headerFont: Pretendard.Style
    private let headerBottomPadding: CGFloat
    /// footer Message
    private let footerMessage: String?

    public var body: some View {
        SectionView(
            content: {
                textField
            },
            header: {
                if let headerText = headerText {
                    HeaderLabel(
                        title: headerText,
                        isRequired: isHeaderRequired,
                        font: headerFont
                    )
                }
            },
            footer: {
                /// 에러 상태일 때, 에러 메세지 띄우는 경우
                if case .error(let errorMessage) = state {
                    label(message: errorMessage)
                }
            }
        )
    }

    private func label(message: String) -> some View {
        Text(message.description)
            .lineSpacing(8)
            .font(.pretendard14(.semibold))
    }
}

public extension YPTextFieldView {
    init(
        @ViewBuilder textField: () -> TextField,
        state: Binding<InputState>,
        headerText: String? = nil,
        isHeaderRequired: Bool = false,
        headerFont: Pretendard.Style = .pretendard16(.semibold),
        headerPadding: CGFloat = 12,
        footerMessage: String? = nil
    ) {
        self.textField = textField()
        self._state = state
        self.headerText = headerText
        self.isHeaderRequired = isHeaderRequired
        self.headerFont = headerFont
        self.headerBottomPadding = headerPadding
        self.footerMessage = footerMessage
    }

    private var labelLineSpacing: CGFloat { return 4 }

    private var footerTopPadding: CGFloat {
        switch state {
        case .default, .focus: return 10
        case .error: return 8
        }
    }
}

#Preview {
    YPTextFieldView(textField: {
        YPTextFieldView(
            textField: {
                TextField("YAPP@email.com", text: .constant(""))
                    .textFieldStyle(.yapp(state: .constant(.focus)))
            },
            state: .constant(.default),
            headerText: "이메일",
            isHeaderRequired: false,
            headerPadding: 5
        )
    }, state: .constant(.focus))
}
