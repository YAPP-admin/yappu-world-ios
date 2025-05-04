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
final class TabViewNavigationRouter {
    @ObservationIgnored
    @Dependency(Navigation<TabViewGlobalPath>.self)
    private var navigation
    @ObservationIgnored
    @Dependency(Router<Flow>.self)
    private var flowRouter
    
    @ObservationIgnored
    @Dependency(NotificationRepository.self)
    private var notificationRepository
    
    @ObservationIgnored
    private let cancelBag = CancelBag()
    
    var path: [TabViewGlobalPath] = []
    
    @ObservationIgnored
    var settingViewModel: SettingViewModel?
    
    @ObservationIgnored
    var homeViewModel: HomeViewModel
    
    @ObservationIgnored
    var noticeViewModel: NoticeViewModel?
    
    @ObservationIgnored
    var noticeDetailViewModel: NoticeDetailViewModel?
    
    @ObservationIgnored
    var myPageViewModel: MyPageViewModel
    
    @ObservationIgnored
    var attendanceListViewModel: AttendanceListViewModel?
    
    @ObservationIgnored
    var preActivitesViewModel: PreActivitiesViewModel?
    
    init() {
        self.homeViewModel = .init()
        self.myPageViewModel = .init()
    }
    
    deinit {
        navigation.cancelBag()
    }
    
    func onTask() async {
        notificationRepository.userInfoPublisher()
            .compactMap(\.self)
            .sink { [weak self] notification in
                self?.notificationSink(notification)
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

    func clickPopupConfirm() {
        guard let url = URL(string: .카카오톡_채널_URL) else { return }
        navigation.push(path: .safari(url: url))
    }
    
    private func notificationSink(_ notification: NotificationEntity) {
        push(.noticeDetail(id: notification.data))
    }
    
    private func push(_ path: TabViewGlobalPath) {
        switch path {
        case .setting:
            self.settingViewModel = SettingViewModel()
        case .noticeList:
            self.noticeViewModel = NoticeViewModel()
        case .noticeDetail(let id):
            self.noticeDetailViewModel = NoticeDetailViewModel(id: id)
        case .attendances:
            self.attendanceListViewModel = AttendanceListViewModel()
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
