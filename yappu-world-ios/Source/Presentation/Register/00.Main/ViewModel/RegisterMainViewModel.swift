//
//  RegisterMainViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/14/25.
//

import Foundation


@Observable
class RegisterMainViewModel {
    
    var name: String = "dsadas"
    var nameState: InputState = .default
    var nameDisabled: Bool {
        return name.isEmpty
    }
    
    var email: String = ""
    var emailState: InputState = .default
    
    var password: String = ""
    var passwordState: InputState = .default
    
    var confirmPassword: String = ""
    var confirmPasswordState: InputState = .default
    
    var history: [RegisterHistoryEntity] = [RegisterHistoryEntity.init(id: 0, generation: "", position: nil)]
    
}
