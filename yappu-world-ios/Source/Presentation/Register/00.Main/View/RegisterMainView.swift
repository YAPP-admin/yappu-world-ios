//
//  RegisterMainView.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/14/25.
//

import SwiftUI

struct RegisterMainView: View {
    
    @State var viewModel: RegisterMainViewModel = .init()
    
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        //RegisterNameView(viewModel: viewModel)
        //RegisterEmailView(viewModel: viewModel)
        RegisterPasswordView(viewModel: viewModel)
    }
}

#Preview {
    RegisterMainView()
}
