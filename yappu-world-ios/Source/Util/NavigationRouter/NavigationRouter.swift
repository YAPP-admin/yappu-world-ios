//
//  NavigationRouter.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Foundation

import Dependencies
import DependenciesMacros

enum Router<P> {
    case push(path: P)
    case pop
    case popAll
    case swithRoot
}

@DependencyClient
struct NavigationRouter<P> {
    var push: (_ path: P) -> Void
    var pop: () -> Void
    var popAll: () -> Void
    var switchRoot: () -> Void
    var publisher: () -> AsyncStream<Router<P>> = {
        return AsyncStream { $0.finish() }
    }
    var cancelBag: () -> Void
}

extension NavigationRouter: DependencyKey {
    static var liveValue: NavigationRouter {
        var pathContinuation: AsyncStream<Router<P>>.Continuation?
        
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
                pathContinuation?.yield(.swithRoot)
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
