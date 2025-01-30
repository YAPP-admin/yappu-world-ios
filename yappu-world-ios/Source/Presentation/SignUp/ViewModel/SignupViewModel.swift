//
//  RegisterMainViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/14/25.
//

import Foundation
import SwiftUI

import Dependencies

@Observable
class SignupViewModel: NSObject {
    @ObservationIgnored
    @Dependency(NavigationRouter<LoginPath>.self)
    private var loginRouter
    
    func clickNextButton(path: LoginPath) {
        loginRouter.push(path)
    }
    
    func clickBackButton() {
        loginRouter.pop()
    }
}

