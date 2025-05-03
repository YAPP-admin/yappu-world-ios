//
//  Array+Custom.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import Foundation

// 배열 안전 접근 Extension
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
