//
//  MyPagePath.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import Foundation

enum MyPagePath: Hashable {
    case setting            // 설정
    case attendances        // 출석 내역
    case preActivities      // 이전 활동 내역
    case safari(url: URL)
}
