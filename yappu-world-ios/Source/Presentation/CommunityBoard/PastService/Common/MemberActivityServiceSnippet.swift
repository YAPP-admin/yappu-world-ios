//
//  MemberActivityServiceSnippet.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

struct MemberActivityServiceSnippet: View {
    let service: ServiceSnippet

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text(service.name)
                    .font(.pretendard14(.semibold))
                    .foregroundStyle(.yapp(.semantic(.primary(.normal))))
                Text("팀이름")
                    .font(.pretendard12(.regular))
                    .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                Spacer()
                platformIcons
            }
            Text(service.description)
                .font(.pretendard13(.regular))
                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }

    private var platformIcons: some View {
        HStack(spacing: 6) {
            if service.platforms.contains(.app) {
                Image(systemName: "applelogo")
                    .font(.system(size: 11))
                    .foregroundStyle(.gray60)
                Image(systemName: "play.square.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray60)
            }
            if service.platforms.contains(.web) {
                Image(systemName: "globe")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray60)
            }
        }
    }
}

#Preview {
    MemberActivityServiceSnippet(service: .dummy(platforms: [.app, .web]))
        .padding()
}
