//
//  ContentView.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/4/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LoginNavigationView(router: .init(viewModel: .init()))
    }
}

#Preview {
    ContentView()
}
