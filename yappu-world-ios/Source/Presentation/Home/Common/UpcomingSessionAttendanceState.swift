//
//  UpcomingSessionAttendanceState.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/22/25.
//

import Foundation

enum UpcomingSessionAttendanceState: Equatable {
    case INACTIVE_DAY          // 출석 불가능 + 미출석 + 당일
    case INACTIVE_YET(String)  // 출석 불가능 + 미출석 + 당일 이후
    case AVAILABLE             // 출석 가능 + 미출석
    case ATTENDED              // 출석
    case LATE                  // 지각
    case ABSENT                // 결석
    case EARLY_LEAVE           // 조퇴
    case EXCUSED               // 공결
    case NOSESSION             // 세션 정보 없음
    
    var banner: String {
        switch self {
        case .INACTIVE_DAY, .AVAILABLE, .ATTENDED, .LATE, .ABSENT, .EARLY_LEAVE, .EXCUSED:
            "세션 당일이에요! 활기찬 하루 되세요 :) "
        case .INACTIVE_YET:
            "다가오는 세션을 준비해볼까요?"
        case .NOSESSION:
            "다가오는 세션이 없어요."
        }
    }
    
    var button: String {
        switch self {
        case .INACTIVE_DAY:
            "20분 전부터 출석이 가능해요"
        case .INACTIVE_YET(let date):
            "\(date) 세션예정"
        case .AVAILABLE:
            "출석하기"
        case .ATTENDED:
            "출석 완료!"
        case .LATE, .ABSENT:
            "다음엔 조금 더 일찍 오기!"
        case .EARLY_LEAVE:
            "다음엔 끝까지 함께 해요~"
        case .EXCUSED:
            "다음 세션엔 함께 해요!"
        case .NOSESSION:
            ""
        }
    }
    
    var isDisabled: Bool {
        switch self {
        case .INACTIVE_DAY, .INACTIVE_YET: true
        default: false
        }
    }
}
