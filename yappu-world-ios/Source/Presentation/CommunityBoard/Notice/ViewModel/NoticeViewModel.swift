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
    @Dependency(Navigation<TabViewGlobalPath>.self)
    private var navigation
    
    @ObservationIgnored
    @Dependency(NoticeUseCase.self)
    private var useCase
    
    @ObservationIgnored
    @Dependency(\.userStorage)
    private var userStorage
    
    private var lastCursorId: String? = nil
    
    var isLoading: Bool = true
    var hasNext: Bool = true
    
    var user: Profile = .dummy()
    var currentUserRole: Member = .Admin
    
    var notices: [NoticeEntity] = [.dummy(), .dummy(), .dummy(), .dummy(), .dummy(), .dummy()]
    
    var selectedNoticeList: NoticeType = .전체 {
        didSet {
            Task {
                await reset()
                try await loadNotices(type: selectedNoticeList, first: true)
            }
        }
    }
    
    private func reset() {
        lastCursorId = nil
        hasNext = true
        isLoading = true
    }
    
    func listTask() async {
        do {
            try await loadNotices(first: true)
        } catch {
            print(error)
        }
    }
    
    func listRefreshable() async {
        do {
            try await loadNotices(first: true)
        } catch {
            print(error)
        }
    }
    
    func loadMore() async {
        do {
            try await loadNotices(type: selectedNoticeList, first: false)
        } catch {
            print(error)
        }
    }
    
    func loadNotices(type: NoticeType = .전체, first: Bool = false) async throws {
        if first { isLoading = true }
        defer { if first { isLoading = false } }
        
        let datas = try await useCase.loadNotices(model: .init(
            lastCursorId: first ? nil : notices.last?.id,
            limit: 30,
            noticeType: type.paramterValue
        ))
        if first { notices.removeAll() }
        
        if let loadNotices = datas?.data.data.map({ $0.toEntity() }) {
            notices.append(contentsOf: loadNotices)
        }
        
        hasNext = datas?.data.hasNext ?? false
        lastCursorId = datas?.data.lastCursor
    }
    
    func errorAction() async {
        notices.removeAll()
    }
    
    func clickNoticeDetail(id: String) {
        navigation.push(path: .noticeDetail(id: id))
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}

