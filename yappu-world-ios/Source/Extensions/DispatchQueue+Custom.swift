//
//  DispatchQueue.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import Foundation

// DispatchQueue extension for async/await
extension DispatchQueue {
    func async<T>(_ work: @escaping () -> T) async -> T {
        return await withCheckedContinuation { continuation in
            self.async {
                let result = work()
                continuation.resume(returning: result)
            }
        }
    }
}
