//
//  NoticeViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import Foundation
import Dependencies
import DependenciesMacros
import Combine

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
    
    private var lastCursorId: String? = nil
    private var isLoading: Bool = false
    private var isLastPage: Bool = false
    
    var isSkeleton: Bool = true
    
    var user: Profile = .dummy()
    var currentUserRole: Member = .Admin
    
    var notices: [NoticeEntity] = [.dummy(), .dummy(), .dummy(), .dummy(), .dummy(), .dummy()]
    
    var selectedNoticeList: NoticeType = .전체 {
        didSet {
            reset()
            Task { try await loadNotices(type: selectedNoticeList, first: true) }
        }
    }
    private func reset() {
        lastCursorId = nil
        isLastPage = false
        isSkeleton = true
        notices.removeAll()
    }
    
    func loadNotices(type: NoticeType = .전체, first: Bool = false) async throws {
        
        guard isLoading.not() else { return }
        
        isLoading = true
        
        guard isLastPage == false else { return }
        
        let datas = try await useCase.loadNotices(model: .init(lastCursorId: lastCursorId, limit: 30, noticeType: type.paramterValue))
        
        if let loadNotices = datas?.data.data.map({ $0.toEntity() }) {
            
            lastCursorId = datas?.data.lastCursor
            
            await MainActor.run {
                
                if first {
                    notices.removeAll()
                }
                
                notices.append(contentsOf: loadNotices)
            }
        }
        
        if datas?.data.hasNext == false {
            isLastPage = true
        }
        
        isLoading = false
        
        await MainActor.run {
            if isSkeleton {
                isSkeleton = false
            }
        }
    }
    
    func errorAction() async {
        await MainActor.run {
            notices.removeAll()
            isSkeleton = false
        }
    }
    
    func clickNoticeDetail(id: String) {
        navigation.push(path: .noticeDetail(id: id))
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}

