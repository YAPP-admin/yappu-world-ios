//
//  HomePath.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/19/25.
//

import Foundation

enum HomePath: Hashable {
    case setting
    case noticeList
    case noticeDetail(id: String)
}
