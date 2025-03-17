//
//  HomeNavigationRouter.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/19/25.
//

import Foundation
import Observation
import Combine

import Dependencies

@Observable
final class HomeNavigationRouter {
    @ObservationIgnored
    @Dependency(Navigation<HomePath>.self)
    private var navigation
    @ObservationIgnored
    @Dependency(FlowRouter.self)
    private var flowRouter
    
    /// 임시
    @ObservationIgnored
    @Dependency(NotificationRepository.self)
    private var notificationRepository
    
    @ObservationIgnored
    private let cancelBag = CancelBag()
    
    var path: [HomePath] = []
    
    @ObservationIgnored
    var settingViewModel: SettingViewModel?
    
    @ObservationIgnored
    var homeViewModel: HomeViewModel
    
    @ObservationIgnored
    var noticeViewModel: NoticeViewModel?
    
    @ObservationIgnored
    var noticeDetailViewModel: NoticeDetailViewModel?
    
    init() {
        self.homeViewModel = .init()
    }
    
    deinit {
        navigation.cancelBag()
    }
    
    func onAppear() async {
        notificationRepository.userInfoPublisher()
            .compactMap(\.self)
            .sink { [weak self] userInfo in
                self?.push(.setting)
            }
            .cancel(with: cancelBag)
        
        await pathSubscribe()
    }
    
    /// 임시
    func clickButton() {
        navigation.push(.setting)
    }
    
    func clickNoticeList() {
        navigation.push(.noticeList)
    }
    
    private func push(_ path: HomePath) {
        switch path {
        case .setting:
            self.settingViewModel = SettingViewModel()
        case .noticeList:
            self.noticeViewModel = NoticeViewModel()
        case .noticeDetail(let id):
            self.noticeDetailViewModel = NoticeDetailViewModel(id: id)
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
