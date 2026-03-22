//
//  SerialTaskQueue.swift
//  yappu-world-ios
//
//  Created by 김도형 on 12/7/25.
//

import Foundation

/// 직렬 Task Queue Actor
actor SerialTaskQueue {
    private var pendingOperations: [() async -> Void] = []
    private var isExecuting = false

    func enqueue(_ operation: @escaping () async -> Void) async {
        pendingOperations.append(operation)
        await executeNextIfNeeded()
    }

    private func executeNextIfNeeded() async {
        guard !isExecuting, !pendingOperations.isEmpty else { return }

        isExecuting = true

        while !pendingOperations.isEmpty {
            let operation = pendingOperations.removeFirst()
            await operation()
        }

        isExecuting = false
    }
}
