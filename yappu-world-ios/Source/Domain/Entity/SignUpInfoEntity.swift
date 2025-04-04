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
    var fcmToken: String?
    var deviceAlarmToggle: Bool
    
    init(
        email: String = "",
        password: String = "",
        name: String = "",
        registerHistory: [RegisterHistory] = [],
        signUpCode: String? = nil,
        fcmToken: String? = nil,
        deviceAlarmToggle: Bool = false
    ) {
        self.email = email
        self.password = password
        self.name = name
        self.registerHistory = registerHistory
        self.signUpCode = signUpCode
        self.fcmToken = fcmToken
        self.deviceAlarmToggle = deviceAlarmToggle
    }
}

extension SignUpInfoEntity {
    struct RegisterHistory: Hashable, Equatable {
        var id: Int
        let old: Bool
        var generation: String = ""
        var position: Position?
        var state: InputState = .default
        
        init(id: Int, old: Bool = true) {
            self.id = id
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
