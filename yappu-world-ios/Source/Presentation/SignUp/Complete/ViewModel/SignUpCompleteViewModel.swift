//
//  SignUpCompleteViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/12/25.
//

import Observation

@Observable
class SignUpCompleteViewModel {
    struct Model {
        var signUpState: SignUpState
        
        init(signUpState: SignUpState) {
            self.signUpState = signUpState
        }
    }
    
    var model: Model
    
    init(model: Model) {
        self.model = model
    }
}

extension SignUpCompleteViewModel {
    enum SignUpState {
        case complete
        case standby
    }
}
