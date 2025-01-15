//
//  LoginViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/4/25.
//

import Foundation
import Combine
import SwiftUI
import Dependencies

protocol LoginViewModelDelegate: AnyObject {
    func clickPopupNextButton()
}

@Observable
class LoginViewModel {
    // 아직 몰라서 그냥 example에 있는 코드 적어봄
    @ObservationIgnored
    @Dependency(\.continuousClock) var clock
    
    var email: String = ""
    var emailState: InputState = .default
    
    var password: String = ""
    var passwordState: InputState = .default
    
    var isValid: Bool {
        return email.isEmpty.not() && password.isEmpty.not()
    }
    
    var registerButtonOpen: Bool = false
    
    var serviceBool: Bool = false
    var privacyBool: Bool = false
    var marketingBool: Bool = false
    
    var registerIsValid: Bool {
        return serviceBool && privacyBool
    }
    
    weak var delegate: (any LoginViewModelDelegate)?
    
    func clickRegisterButton() {
        withAnimation {
            registerButtonOpen.toggle()
        }
    }
    
    func clickPopupNextButton() {
        delegate?.clickPopupNextButton()
    }
}
