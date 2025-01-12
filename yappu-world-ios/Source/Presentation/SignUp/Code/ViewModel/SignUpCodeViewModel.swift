//
//  CodeViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/12/25.
//

import SwiftUI

protocol SignUpCodeViewModelDelegate: AnyObject {
    func clickNextButton(_ viewModel: SignUpCodeViewModel)
}

@Observable
class SignUpCodeViewModel: NSObject {
    struct Model {
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
    
    var model: Model
    
    @ObservationIgnored
    var delegate: (any SignUpCodeViewModelDelegate)?
    
    init(model: Model) {
        self.model = model
    }
    
    func clickNextButton() {
        delegate?.clickNextButton(self)
    }
}
