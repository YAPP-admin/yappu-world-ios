//
//  Image+Custom.swift
//  yappu-world-ios
//
//  Created by 김건형 on 10/7/25.
//

import SwiftUI

extension Image {

    func infoIconStyle() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 16)
            .foregroundStyle(.accentCoolNatural)
            .offset(y: 3) // 디자인 상 미세 보정
    }
}
