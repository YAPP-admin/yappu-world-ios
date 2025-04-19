//
//  Router.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/28/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct Router<T> {
    var `switch`: (T) -> Void
    var publisher: () -> AsyncStream<T> = {
        return AsyncStream { $0.finish() }
    }
    var cancelBag: () -> Void
}

extension Router: DependencyKey {
    static var liveValue: Router {
        var continuation: AsyncStream<T>.Continuation?
        
        return Self(
            switch: { continuation?.yield($0) },
            publisher: {
                AsyncStream { continuation = $0 }
            },
            cancelBag: { continuation?.finish() }
        )
    }
}
