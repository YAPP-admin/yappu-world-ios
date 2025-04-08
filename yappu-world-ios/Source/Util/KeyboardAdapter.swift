//
//  KeyboardAdapter.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/6/25.
//

import SwiftUI
import UIKit

// iOS 15 이상에서 사용 가능한 KeyboardAdapter
@available(iOS 15.0, *)
struct KeyboardAdapter: ViewModifier {
    @Binding var keyboardOn: Bool
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                self.keyboardOn = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                self.keyboardOn = false
            }
    }
}

// iOS 15 이상용 View 확장
@available(iOS 15.0, *)
extension View {
    func adaptToKeyboard(keyboardOn: Binding<Bool>) -> some View {
        self.modifier(KeyboardAdapter(keyboardOn: keyboardOn))
    }
}
