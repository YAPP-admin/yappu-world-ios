//
//  SectionView.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/6/25.
//

import SwiftUI

/// HeaderView, Content, FooterView로 나눠져있는 View입니다.
public struct SectionView<Header: View, Content: View, Footer: View>: View {
    @ViewBuilder private let header: Header
    @ViewBuilder private let content: Content
    @ViewBuilder private let footer: Footer

    private let headerPadding: CGFloat
    private let footerPadding: CGFloat

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
                .padding(.bottom, headerPadding)

            content
            
            footer
                .padding(.top, footerPadding)
        }
    }
}

public extension SectionView {
    init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Header = { EmptyView() },
        @ViewBuilder footer: () -> Footer = { EmptyView() },
        headerBottomPadding: CGFloat = 12,
        footerTopPadding: CGFloat = 8
    ) {
        self.content = content()
        self.header = header()
        self.footer = footer()
        self.headerPadding = headerBottomPadding
        self.footerPadding = footerTopPadding
    }
}

struct SectionViewPreviews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            SectionView(
                content: {
                    TextField("예시입니다.", text: .constant(""))
                }, header: {
                    Text("header 입니다.")
                }, footer: {
                    Text("footer 입니다.")
                },
                headerBottomPadding: 12,
                footerTopPadding: 10
            )

            SectionView(
                content: {
                    TextField("ex) 삼성역 5번 출구", text: .constant(""))
                },
                header: {
                    HeaderLabel(
                        title: "희망 접선 장소",
                        isRequired: true,
                        font: .pretendard16(.semibold)
                    )
                }
            )

            SectionView(
                content: {
                    TextField("예시 메일 입니다.", text: .constant(""))
                },
                header: {
                    HeaderLabel(
                        title: "회사 메일을 입력해 주세요.",
                        isRequired: false,
                        font: .pretendard22(.bold)
                    )
                },
                headerBottomPadding: 24
            )
        }
        .padding()
    }
}
