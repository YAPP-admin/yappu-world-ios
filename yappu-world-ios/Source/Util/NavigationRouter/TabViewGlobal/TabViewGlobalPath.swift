//
//  TabViewGlobalPath.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/19/25.
//

import Foundation

enum TabViewGlobalPath: Hashable {
    case setting
    case noticeList
    case noticeDetail(id: String)
    case safari(url: URL)
    case attendances        // 출석 내역
    case preActivities      // 이전 활동 내역
}
