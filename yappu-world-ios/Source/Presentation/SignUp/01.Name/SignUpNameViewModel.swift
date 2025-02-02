//
//  SignUpNameViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Observation

import Dependencies

@Observable
final class SignUpNameViewModel {
    @ObservationIgnored
    @Dependency(Navigation<LoginPath>.self)
    private var navigation
    
    var name: String = ""
    var nameState: InputState = .default
    var nameDisabled: Bool {
        return name.isEmpty
    }
    
    func clickNextButton() {
        navigation.push(path: .email(SignUpInfoEntity(name: name)))
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}
