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
    
    var banner: String? {
        switch self {
        case .INACTIVE_DAY, .AVAILABLE:
            "세션 당일이에요! 활기찬 하루 되세요 :)"
        case .INACTIVE_YET:
            "다가오는 세션을 준비해볼까요?"
        case .ATTENDED, .LATE, .EARLY_LEAVE, .EXCUSED, .ABSENT:
            nil
        case .NOSESSION:
            "다가오는 세션이 없어요."
        }
    }
    
    var button: String {
        switch self {
        case .INACTIVE_DAY:
            "20분 전부터 출석 할수 있어요!"
        case .INACTIVE_YET(let date):
            "\(date) 세션 예정"
        case .AVAILABLE:
            "출석하기"
        case .ATTENDED:
            "출석완료!"
        case .LATE:
            "다음엔 조금 더 일찍오기!"
        case .ABSENT:
            "세션이 종료됐어요"
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
        case .INACTIVE_DAY, .INACTIVE_YET, .ABSENT: true
        default: false
        }
    }
}
