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
    var selectedNoticeDisplayTargets: [DisplayTargetType] = [.All]
    var preSelectedNoticeDisplayTargets: [DisplayTargetType] = [.All]
    
    var bottomPopupIsOpen: Bool = true
    
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
    
    func controlDisplayTarget(_ displayTarget: DisplayTargetType) {
        
        if let index = preSelectedNoticeDisplayTargets.firstIndex(of: displayTarget) {
            
            if preSelectedNoticeDisplayTargets.count == 1 { return }
            
            preSelectedNoticeDisplayTargets.remove(at: index)
        } else {
            preSelectedNoticeDisplayTargets.append(displayTarget)
        }
    }
    
    func applyDisplayTarget() {
        selectedNoticeDisplayTargets = preSelectedNoticeDisplayTargets
        bottomPopupIsOpen = false
    }
    
    func noticeDisplayTargetText() -> String {
        if selectedNoticeDisplayTargets.count == 1 {
            return selectedNoticeDisplayTargets.first?.text ?? ""
        } else {
            return "\(selectedNoticeDisplayTargets.count)개 선택됨"
        }
    }
    
    func openBottomPopup() {
        bottomPopupIsOpen.toggle()
    }
    
    func clickNoticeDetail(id: String) {
        navigation.push(path: .noticeDetail(id: id))
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}

