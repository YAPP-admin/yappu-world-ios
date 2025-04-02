//
//  SplashView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/28/25.
//

import SwiftUI

struct SplashView: View {
    @State
    private var viewModel = SplashViewModel()
    
    var body: some View {
        Text("Splash")
            .task { await viewModel.onTask() }
    }
}

#Preview {
    SplashView()
}
