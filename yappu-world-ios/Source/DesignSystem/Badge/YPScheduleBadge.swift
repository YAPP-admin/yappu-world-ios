//
//  YPScheduleBadge.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/19/25.
//

import SwiftUI

enum YPScheduleBadgeType {
    case upcoming
    case attendance
    case nonattendance
    case leavingEarly
    case approvedAbsence
    case late
    case none
    
    var text: String {
        switch self {
        case .upcoming: return "예정"
        case .attendance: return "출석"
        case .late: return "지각"
        case .nonattendance: return "결석"
        case .leavingEarly: return "조퇴"
        case .approvedAbsence: return "공결"
        default: return ""
        }
    }
    
    var textColor: Color {
        switch self {
        case .upcoming: return .yapp(.semantic(.secondary(.normal)))
        case .attendance: return .yapp(.semantic(.accent(.lightBlue)))
        case .late: return .lateGray
        case .nonattendance: return .yapp(.semantic(.accent(.red)))
        case .leavingEarly: return .yapp(.semantic(.accent(.violet)))
        case .approvedAbsence: return .approvedAbsenceGray
        case .none: return .clear
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .upcoming: return .yapp(.semantic(.accent(.yellowWeak)))
        case .attendance: return .yapp(.semantic(.accent(.lightBlueWeak)))
        case .late: return .yapp(.semantic(.accent(.coolNaturalWeak)))
        case .nonattendance: return .yapp(.semantic(.accent(.redWeak)))
        case .leavingEarly: return .yapp(.semantic(.accent(.violetWeak)))
        case .approvedAbsence: return Color.init(hex: "#DCDCDC")
        case .none: return .clear
        }
    }
    
    init(_ value: String) {
        switch value {
        case "예정": self = .upcoming
        case "출석": self = .attendance
        case "지각": self = .late
        default: self = .none
        }
    }
}

struct YPScheduleBadge: View {
    
    var type : YPScheduleBadgeType
    
    init(type: YPScheduleBadgeType) {
        self.type = type
    }
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundStyle(type.backgroundColor)
                
                Text(type.text)
                    .font(.pretendard11(.regular))
                    .foregroundStyle(type.textColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
            }
            .fixedSize()
        }
    }
}

#Preview {
    VStack {
        YPScheduleBadge(type: .upcoming)
        YPScheduleBadge(type: .attendance)
        YPScheduleBadge(type: .late)
        YPScheduleBadge(type: .nonattendance)
        YPScheduleBadge(type: .leavingEarly)
        YPScheduleBadge(type: .approvedAbsence)
    }
}
