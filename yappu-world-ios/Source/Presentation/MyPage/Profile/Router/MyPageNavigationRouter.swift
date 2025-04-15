//
//  MyPageNavigationRouter.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import Foundation
import Observation
import Combine

import Dependencies

@Observable
final class MyPageNavigationRouter {
    @ObservationIgnored
    @Dependency(Navigation<MyPagePath>.self)
    private var navigation
    
    @ObservationIgnored
    @Dependency(FlowRouter.self)
    private var flowRouter

    @ObservationIgnored
    private let cancelBag = CancelBag()
    
    var path: [MyPagePath] = []
    
    @ObservationIgnored
    var myPageViewModel: MyPageViewModel
    
    @ObservationIgnored
    var settingViewModel: SettingViewModel?
    
    @ObservationIgnored
    var preActivitesViewModel: PreActivitiesViewModel?
    
    init() {
        self.myPageViewModel = .init()
    }
    
    deinit {
        navigation.cancelBag()
    }
    
    func onTask() async {
        await pathSubscribe()
    }
    
    private func push(_ path: MyPagePath) {
        switch path {
        case .setting:
            self.settingViewModel = SettingViewModel()
        case .attendances:
            break
        case .preActivities:
            self.preActivitesViewModel = PreActivitiesViewModel()
        case .safari: break
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
