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
    
    @ObservationIgnored
    private var lastCursorId: String? = nil
    
    @ObservationIgnored
    private var firstAppear = false
    
    var isLoading: Bool = true
    var hasNext: Bool = false
    var notices: [NoticeEntity] = [.dummy(), .dummy(), .dummy(), .dummy(), .dummy(), .dummy()]
    
    var selectedNoticeList: NoticeType = .전체 {
        didSet {
            reset()
            Task {
                isLoading = true
                do {
                    try await loadNotices()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func reset() {
        lastCursorId = nil
        hasNext = true
    }
    
    @Sendable
    func listTask() async {
        guard !firstAppear else { return }
        defer { firstAppear = true }
        reset()
        do {
            try await loadNotices()
        } catch {
            print(error)
        }
    }
    
    @Sendable
    func listRefreshable() async {
        reset()
        do {
            try await loadNotices()
        } catch {
            print(error)
        }
    }
    
    func loadMore() async {
        do {
            try await loadNotices()
        } catch {
            print(error)
        }
    }
    
    func loadNotices() async throws {
        let datas = try await useCase.loadNotices(model: .init(
            lastCursorId: lastCursorId,
            limit: 30,
            noticeType: selectedNoticeList.paramterValue
        ))
        defer {
            lastCursorId = datas?.data.lastCursor
            isLoading = false
            hasNext = datas?.data.hasNext ?? false
        }
        guard let loadNotices = datas?.data.data.map({ $0.toEntity() }) else {
            return
        }
        if lastCursorId == nil {
            notices = loadNotices
        } else {
            notices.append(contentsOf: loadNotices)
        }
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
