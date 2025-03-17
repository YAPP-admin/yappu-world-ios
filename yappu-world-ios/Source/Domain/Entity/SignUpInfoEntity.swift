//
//  SignUpEntity.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Foundation

struct SignUpInfoEntity: Hashable, Equatable {
    var email: String
    var password: String
    var name: String
    var registerHistory: [RegisterHistory]
    var signUpCode: String?
    
    init(
        email: String = "",
        password: String = "",
        name: String = "",
        registerHistory: [RegisterHistory] = [],
        signUpCode: String? = nil
    ) {
        self.email = email
        self.password = password
        self.name = name
        self.registerHistory = registerHistory
        self.signUpCode = signUpCode
    }
}

extension SignUpInfoEntity {
    struct RegisterHistory: Hashable, Equatable {
        var id: Int = 0
        let old: Bool
        var generation: String = ""
        var position: Position?
        var state: InputState = .default
        
        init(id: Int = 0, old: Bool = true) {
            self.old = old
        }
    }
}

enum Position: String {
    case PM = "PM"
    case UIUX_Design = "UXUI Design"
    case Android = "Android"
    case iOS = "iOS"
    case Web = "Web"
    case Server = "Server"
    case Staff = "Staff"
    case Flutter = "Flutter"
    
    /*
     PM, DESIGN, WEB, ANDROID, IOS, FLUTTER, SERVER, STAFF
     */
    
    static func convert(_ value: String) -> Self? {
        switch value {
        case "IOS": return .iOS
        case "PM": return .PM
        case "DESIGN": return .UIUX_Design
        case "ANDROID": return .Android
        case "SERVER": return .Server
        case "STAFF": return .Staff
        case "FLUTTER": return .Flutter
        case "WEB": return .Web
        default: return nil
        }
    }
}
