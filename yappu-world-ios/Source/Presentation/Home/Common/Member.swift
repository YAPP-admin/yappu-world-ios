//
//  Member.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import SwiftUI

enum Member {
    
    /*
     
     관리자 = Admin
     운영진 = Staff
        
     활동회원 = Active
     정회원 = Associate
     수료회원 = Certified
     
     */
    
    case Admin
    case Staff
    case Active
    case Associate
    case Certified
    
    var color: Color {
        switch self {
        case .Admin:
            return .adminGray
        case .Staff:
            return .adminGray
        case .Active:
            return .activeMemberColor
        case .Associate:
            return .certifiedMemberColor
        case .Certified:
            return .certifiedMemberColor
        }
    }
    
    var description: String {
        switch self {
        case .Admin: "관리자"
        case .Staff: "운영진"
        case .Active: "활동회원"
        case .Associate: "정회원"
        case .Certified: "수료회원"
        }
    }
    
    static func convert(_ value: String) -> Self {
        switch value {
        case "관리자": .Admin
        case "운영진": .Staff
        case "활동회원": .Active
        case "정회원": .Associate
        case "수료회원": .Certified
        default: .Active
        }
    }
}
