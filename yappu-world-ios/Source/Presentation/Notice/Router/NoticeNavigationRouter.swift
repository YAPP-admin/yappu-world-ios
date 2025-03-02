//
//  NoticeRouter.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/23/25.
//

import Dependencies
import Foundation

@Observable
final class NoticeNavigationRouter {
    @ObservationIgnored
    @Dependency(Navigation<NoticePath>.self)
    private var navigation
    
    var path: [NoticePath] = []
    
    @ObservationIgnored
    var noticeViewModel: NoticeViewModel?
    
    deinit {
        navigation.cancelBag()
    }
    
    func onAppear() async {
        await pathSubscribe()
    }
    
    func clickDetail(id: Int) {
        navigation.push(path: .Detail(id: id))
    }
    
    @MainActor
    private func pathSubscribe() async {
        for await action in navigation.publisher() {
            switch action {
            case let .push(path):
                self.push(path)
            case .pop:
                path.removeLast()
            case .popAll:
                path.removeAll()
            case .switchFlow(let flow):
                break
            }
        }
    }
    
    private func push(_ path: NoticePath) {
        switch path {
        case .Detail(let id):
            self.noticeViewModel = NoticeViewModel()
        }
        
        self.path.append(path)
    }
}
