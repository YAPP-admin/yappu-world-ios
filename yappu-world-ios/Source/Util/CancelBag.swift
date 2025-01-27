//
//  CancelBag.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/27/25.
//

import Combine
import Foundation
import SwiftUI


final class CancelBag {
    fileprivate var cancellables: Set<AnyCancellable> = []
    
    func cancel() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        self.cancellables.formUnion(cancellables())
    }
    
    deinit {
        cancel()
    }
}

extension CancelBag {
    @resultBuilder
    struct Builder {
        static func buildBlock(_ components: AnyCancellable...) -> [AnyCancellable] {
            components
        }
    }
}

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.cancellables.insert(self)
    }
}
