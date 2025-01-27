//
//  Navigation+Custom.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/27/25.
//

import SwiftUI

struct CustomBackButtonModifier: ViewModifier {
    
    var router: LoginNavigationRouter
    var toHome: Bool
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if toHome { router.backToHome() } else { router.back() }
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.labelGray)
                        }
                    }
                }
            }
    }
}

extension View {
    func backButton(router: LoginNavigationRouter, toHome: Bool = true) -> some View {
        modifier(CustomBackButtonModifier(router: router, toHome: toHome))
    }
}
