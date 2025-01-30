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
    @Dependency(Navigation<LoginPath>.self)
    private var navigation
    
    func clickNextButton(path: LoginPath) {
        navigation.push(path)
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}

