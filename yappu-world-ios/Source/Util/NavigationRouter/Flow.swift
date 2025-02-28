//
//  Flow.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/28/25.
//

import Foundation

import Dependencies
import DependenciesMacros

enum Flow {
    case home
    case login
}

@DependencyClient
struct FlowRouter {
    var `switch`: (Flow) -> Void
    var publisher: () -> AsyncStream<Flow> = {
        return AsyncStream { $0.finish() }
    }
    var cancelBag: () -> Void
}

extension FlowRouter: DependencyKey {
    static let liveValue = {
        var continuation: AsyncStream<Flow>.Continuation?
        
        return Self(
            switch: { continuation?.yield($0) },
            publisher: {
                AsyncStream { continuation = $0 }
            },
            cancelBag: { continuation?.finish() }
        )
    }()
}
