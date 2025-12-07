//
//  SerialTaskQueue.swift
//  yappu-world-ios
//
//  Created by 김도형 on 12/7/25.
//

import Foundation

/// 직렬 Task Queue Actor
actor SerialTaskQueue {
    private var currentTask: Task<Void, Never>?
    
    func enqueue(_ operation: @escaping () async -> Void) {
        let previousTask = currentTask
        
        currentTask = Task {
            // 이전 task가 완료될 때까지 대기
            await previousTask?.value
            
            // 현재 operation 실행
            await operation()
        }
    }
}
