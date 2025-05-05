//
//  UpcomingSessionAttendanceState.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/22/25.
//

import Foundation

enum UpcomingSessionAttendanceState: Equatable {
    case Inactive_Dday         // 출석 불가능 + 미출석 + 당일
    case Inactive_Yet(String)  // 출석 불가능 + 미출석 + 당일 이후
    case Available             // 출석 가능 + 미출석
    case Attended              // 이미 출석함
    case NoSession             // 세션 정보 없음
    
    var banner: String {
        switch self {
        case .Inactive_Dday, .Available, .Attended:
            "세션 당일이에요! 활기찬 하루 되세요 :) "
        case .Inactive_Yet:
            "다가오는 세션을 준비해볼까요?"
        case .NoSession:
            "다가오는 세션이 없어요."
        }
    }
    
    var button: String {
        switch self {
        case .Inactive_Dday:
            "20분 전부터 출석이 가능해요"
        case .Inactive_Yet(let date):
            "\(date) 세션예정"
        case .Available:
            "출석하기"
        case .Attended:
            "출석완료!"
        default: ""
        }
    }
    
    var isDisabled: Bool {
        switch self {
        case .Inactive_Dday, .Inactive_Yet: true
        default: false
        }
    }
}
