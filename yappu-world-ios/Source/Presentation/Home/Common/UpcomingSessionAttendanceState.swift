//
//  UpcomingSessionAttendanceState.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/22/25.
//

import Foundation

enum UpcomingSessionAttendanceState {
    case Inactive(Date)     // 출석 불가능 + 미출석
    case Available          // 출석 가능 + 미출석
    case Attended           // 이미 출석함
    case NoSession          // 세션 정보 없음
    
    var banner: String {
        switch self {
        case .Inactive:
            "다가오는 세션을 준비해볼까요?"
        case .Available, .Attended:
            "세션 당일이에요! 활기찬 하루 되세요 :) "
        case .NoSession:
            ""
        }
    }
    
    var title: String {
        switch self {
        case .Inactive:
            "오늘은 \(Date().formatted(as: "MM월 dd일"))이에요."
        case .Available, .Attended:
            ""
        case .NoSession:
            ""
        }
    }
    
    var button: String {
        switch self {
        case .Inactive(let date):
            "\(date.formatted(as: "MM월 dd일")) 세션예정"
        case .Available:
            "출석하기"
        case .Attended:
            "출석완료!"
        case .NoSession:
            ""
        }
    }
}
//
//enum UpcomingStatusType {
//    
//    /*
//     
//     관리자 = Admin
//     운영진 = Staff
//        
//     활동회원 = Active
//     정회원 = Associate
//     수료회원 = Certified
//     
//     */
//    
//    case n
//    case Staff
//    case Active
//    
//    var color: Color {
//        switch self {
//        case .Admin:
//            return .adminGray
//        case .Staff:
//            return .adminGray
//        case .Active:
//            return .activeMemberColor
//        case .Associate:
//            return .certifiedMemberColor
//        case .Certified:
//            return .certifiedMemberColor
//        }
//    }
//    
//    var description: String {
//        switch self {
//        case .Admin: "관리자"
//        case .Staff: "운영진"
//        case .Active: "활동회원"
//        case .Associate: "정회원"
//        case .Certified: "수료회원"
//        }
//    }
//    
//    static func convert(_ value: String) -> Self {
//        switch value {
//        case "관리자": .Admin
//        case "운영진": .Staff
//        case "활동회원": .Active
//        case "정회원": .Associate
//        case "수료회원": .Certified
//        default: .Active
//        }
//    }
//}
