//
//  SignupCodeModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/27/25.
//

import Foundation

struct SignupCodeModel {
    var code: String = ""
    var isValid: Bool {
        return code.isEmpty.not()
    }
    
    init(code: String) {
        self.code = code
    }
}


