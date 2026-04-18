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
        case .late: return "지각 -10"
        case .nonattendance: return "결석 -20"
        case .leavingEarly: return "조퇴"
        case .approvedAbsence: return "공결"
        default: return ""
        }
    }
    
    var textColor: Color {
        switch self {
        case .upcoming: return .yapp(.semantic(.secondary(.normal)))
        case .attendance: return .yapp(.semantic(.accent(.lightBlue)))
        case .late: return .yapp(.semantic(.accent(.coolNatural)))
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
        case .late: return .yapp(.semantic(.fill(.alternative)))
        case .nonattendance: return .yapp(.semantic(.accent(.redWeak)))
        case .leavingEarly: return .yapp(.semantic(.accent(.violetWeak)))
        case .approvedAbsence: return Color.init(hex: "#DCDCDC")
        case .none: return .clear
        }
    }
    
    init(_ value: String) {
        switch value {
        case "예정", "PENDING": self = .upcoming
        case "출석", "ON_TIME": self = .attendance
        case "지각", "LATE": self = .late
        case "결석", "ABSENT": self = .nonattendance
        case "조퇴", "EARLY_CHECK_OUT": self = .leavingEarly
        case "공결", "EXCUSED_ABSENCE": self = .approvedAbsence
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
                    .padding(.vertical, 4)
                // 실제 디자인과 맞추기 위해서 text lineheight가 무시된 만큼 임의 값 추가 -> 추후 text자체에 대한 수정 필요
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
