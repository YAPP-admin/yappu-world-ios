//
//  NoticeViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@Observable
class NoticeViewModel {
    
    @ObservationIgnored
    @Dependency(Navigation<HomePath>.self)
    private var navigation
    
    @ObservationIgnored
    @Dependency(NoticeUseCase.self)
    private var useCase
    
    @ObservationIgnored
    @Dependency(\.userStorage)
    private var userStorage
    
    private var currentPage: NoticeRequest = .init(limit: 30, noticeType: "ALL")
    private var isLoading: Bool = false
    private var isLastPage: Bool = false
    
    var user: Profile = .dummy()
    var currentUserRole: Member = .Admin
    
    var notices: [NoticeEntity] = []
    
    var selectedNoticeList: NoticeType = .전체
    
    func loadNotices() async throws {
        
        guard isLastPage == false else { return }
        
        let datas = try await useCase.loadNotices(model: .init(limit: 30, noticeType: "ALL"))
        
        if let loadNotices = datas?.data.data.map({ $0.toEntity() }) {
            notices.append(contentsOf: loadNotices)
        }
        
        if datas?.data.hasNext == false {
            isLastPage = true
        }
    }
    
    func clickNoticeDetail(id: String) {
        navigation.push(path: .noticeDetail(id: id))
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}

