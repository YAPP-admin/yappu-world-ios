//
//  Navigation+Custom.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/27/25.
//

import SwiftUI

struct CustomBackButtonModifier: ViewModifier {
    var action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: action) {
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
    func backButton(action: @escaping () -> Void) -> some View {
        modifier(CustomBackButtonModifier(action: action))
    }
}
