//
//  SignupCodeModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/27/25.
//

import Foundation

struct SignupCodeModel {
    var code1: String = ""
    var code2: String = ""
    var code3: String = ""
    var code4: String = ""
    var isValid: Bool {
        return code1.isEmpty.not()
        && code2.isEmpty.not()
        && code3.isEmpty.not()
        && code4.isEmpty.not()
    }
    
    init() { }
}


