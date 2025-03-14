//
//  HomeNavigationRouter.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/19/25.
//

import Foundation
import Observation

import Dependencies

@Observable
final class HomeNavigationRouter {
    @ObservationIgnored
    @Dependency(Navigation<HomePath>.self)
    private var navigation
    @ObservationIgnored
    @Dependency(FlowRouter.self)
    private var flowRouter
    
    var path: [HomePath] = []
    
    @ObservationIgnored
    var settingViewModel: SettingViewModel?
    
    deinit {
        navigation.cancelBag()
    }
    
    func onAppear() async {
        await pathSubscribe()
    }
    
    /// 임시
    func clickButton() {
        navigation.push(.setting)
    }
    
    private func push(_ path: HomePath) {
        switch path {
        case .setting:
            self.settingViewModel = SettingViewModel()
        }
        self.path.append(path)
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
            case let .switchFlow(flow):
                // TODO: 루트 네비게이션 변경
                flowRouter.switch(flow)
                break
            }
        }
    }
}
