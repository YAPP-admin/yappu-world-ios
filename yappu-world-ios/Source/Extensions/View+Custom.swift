//
//  View+Custom.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/7/25.
//

import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func clipRectangle(_ radius: CGFloat) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .clipped()
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    @ViewBuilder
    func systemNavigationBarHidden(_ hidden: Bool = true) -> some View {
        if #available(iOS 18.0, *) {
            self.toolbarVisibility(hidden ? .hidden : .visible, for: .navigationBar)
        } else {
            self.navigationBarBackButtonHidden()
        }
    }
    
    @ViewBuilder
    func systemTabBarHidden() -> some View {
        if #available(iOS 18.0, *) {
            self.toolbarVisibility(.hidden, for: .tabBar)
        } else {
            self.toolbar(.hidden, for: .tabBar)
        }
    }
}
