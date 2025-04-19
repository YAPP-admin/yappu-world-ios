//
//  CommunityView.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/14/25.
//

import SwiftUI

struct CommunityView: View {
    var body: some View {
        VStack {
            Image("errorYappu")
            
            Text("열심히 만들고 있어요! 우리 곧 만나요 :)")
                .multilineTextAlignment(.center)
                .font(.pretendard14(.regular))
                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                .padding(.top, 23)
        }
    }
}

#Preview {
    CommunityView()
}
