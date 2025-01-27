//
//  SignupCompleteModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/27/25.
//

import Foundation

struct SignupCompleteModel {
    var signUpState: SignUpState
    
    init(signUpState: SignUpState) {
        self.signUpState = signUpState
    }
}

enum SignUpState {
    case complete
    case standby
}
