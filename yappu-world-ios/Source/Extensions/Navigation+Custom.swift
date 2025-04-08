//
//  Navigation+Custom.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/27/25.
//

import SwiftUI

struct CustomBackButtonModifier: ViewModifier {

    var title: String?
    var useBackButton: Bool = true
    var action: () -> Void

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    
                    
                    if useBackButton {
                        Button(action: action) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(.labelGray)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 14)
                
                HStack {
                    if let title {
                        Text(title)
                            .font(.pretendard18(.semibold))
                            .foregroundColor(.labelGray)
                    }
                }
            }
            .frame(height: 56)
            
            content
                .navigationBarBackButtonHidden(true)
        }
        
    }
}

extension View {
    func backButton(title: String? = nil, useBackButton: Bool = true, action: @escaping () -> Void) -> some View {
        modifier(CustomBackButtonModifier(title: title, useBackButton: useBackButton, action: action))
    }
}
