//
//  NavigationRouter.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct Navigation<P> {
    var push: (_ path: P) -> Void
    var pop: () -> Void
    var popAll: () -> Void
    var switchRoot: () -> Void
    var publisher: () -> AsyncStream<Action> = {
        return AsyncStream { $0.finish() }
    }
    var cancelBag: () -> Void
}

extension Navigation {
    enum Action {
        case push(path: P)
        case pop
        case popAll
        case switchRoot
    }
}

extension Navigation: DependencyKey {
    static var liveValue: Navigation {
        var pathContinuation: AsyncStream<Action>.Continuation?
        
        return Self(
            push: { path in
                pathContinuation?.yield(.push(path: path))
            },
            pop: {
                pathContinuation?.yield(.pop)
            },
            popAll: {
                pathContinuation?.yield(.popAll)
            },
            switchRoot: {
                pathContinuation?.yield(.switchRoot)
            },
            publisher: {
                AsyncStream { continuation in
                    pathContinuation = continuation
                }
            },
            cancelBag: {
                pathContinuation?.finish()
            }
        )
    }
}
