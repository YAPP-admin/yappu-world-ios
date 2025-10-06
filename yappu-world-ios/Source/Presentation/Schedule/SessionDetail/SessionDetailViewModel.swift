//
//  SessionDetailViewModel.swift
//  yappu-world-ios
//
//  Created by 김건형 on 9/26/25.
//

import Foundation
import SwiftUI
import Dependencies
import DependenciesMacros

@Observable
class SessionDetailViewModel {
    @ObservationIgnored
    @Dependency(Navigation<TabViewGlobalPath>.self)
    var navigation
    
    @ObservationIgnored
    @Dependency(\.userStorage)
    private var userStorage
    
    @ObservationIgnored
    @Dependency(SessionUseCase.self)
    private var useCase
    
    @ObservationIgnored
    @Dependency(NoticeUseCase.self)
    private var noticeUseCase

    
    var id: String // 세션 Id
    var isSkeleton: Bool = false
    var sessionEntity: SessionDetailEntity? = .dummy()
    var isSelected: YPSectionType = .timeTable
    var sections: [YPSectionEntity] = [
        .init(id: .timeTable, title: "타임테이블"),
        .init(id: .notice, title: "공지사항"),
        .init(id: .attend, title: "출석")
    ]

    // Private Property
    private var isInit: Bool = false // 첫 화면이면 더이상 가져오지 않기
    private var lastCursorId: String? = nil
    private var isLoading: Bool = false
    private var isLastPage: Bool = false

    init(id: String) {
        self.id = id
    }
}
// MARK: - User Action
extension SessionDetailViewModel {

    func onTask() async {
        
        guard isInit.not() else { return }
        
        do {
            try await loadSessionDetail()
            isInit = true
        } catch(let error as YPError) {
            await errorAction(error)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func clickBackButton() {
        navigation.pop()
    }
    
    // 공지사항 클릭
    func clickNoticeDetail(id: String) {
        navigation.push(path: .noticeDetail(id: id))
    }
    
    // 공지사항 더 불러오기
//    func loadMore(appearId: String) async throws {
//        guard sessionEntity.notices.count - 3 < notices.firstIndex(where: { $0.id == appearId }) ?? 0 else { return }
//        try await loadNotices(type: selectedNoticeList, first: false)
//    }
    
//    func loadNotices(type: NoticeType = .전체, first: Bool = false) async throws {
//        if first {
//            await reset()
//        }
//        
//        guard isLoading.not() else { return }
//        
//        isLoading = true
//        
//        guard isLastPage == false || first else { return }
//        
//        let datas = try await useCase.loadNotices(model: .init(lastCursorId: lastCursorId, limit: 30, noticeType: type.paramterValue))
//        
//        if let loadNotices = datas?.data.data.map({ $0.toEntity() }) {
//            
//            lastCursorId = datas?.data.lastCursor
//            
//            await MainActor.run {
//                
//                if first {
//                    notices.removeAll()
//                }
//                
//                notices.append(contentsOf: loadNotices)
//            }
//        }
//        
//        if datas?.data.hasNext == false {
//            isLastPage = true
//        }
//        
//        isLoading = false
//        
//        await MainActor.run {
//            if isSkeleton {
//                isSkeleton = false
//            }
//        }
//    }
}

// MARK: - Private Async Methods
private extension SessionDetailViewModel {
    // 세션 상세 조회
    func loadSessionDetail() async throws {
        let sessionResponse = try await useCase.loadSessionDetail(sessionId: id)
        
        await MainActor.run {
            if let sessionResponse = sessionResponse {
                sessionEntity = sessionResponse.data
                
                if isSkeleton {
                    isSkeleton = false
                }
            }
        }
    }
    
    func errorAction(_ error: YPError) async {
        print(error.localizedDescription)
        await MainActor.run {
            YPGlobalPopupManager.shared.show()
            sessionEntity = nil
            isSkeleton = false
            //            isLoading = false
        }
    }
    
    func reset() async {
        await MainActor.run {
            lastCursorId = nil
            isLastPage = false
            isSkeleton = true
            isLoading = false
//            notices.removeAll()
        }
    }
}
