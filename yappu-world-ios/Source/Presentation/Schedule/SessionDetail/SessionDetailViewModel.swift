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
    var isSkeleton: Bool = true
    var sessionEntity: SessionDetailEntity? = .dummy()

    // Private Property
    private var isInit: Bool = false // 첫 화면이면 더이상 가져오지 않기

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
        } catch {
            await errorAction(error)
        }
    }
    
    func clickBackButton() {
        navigation.pop()
    }
    
    // 공지사항 클릭
    func clickNoticeDetail(id: String) {
        navigation.push(path: .noticeDetail(id: id))
    }
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
    
    func errorAction(_ error: Error) async {
        print(error.localizedDescription)
        await MainActor.run {
            YPGlobalPopupManager.shared.show()
            sessionEntity = nil
            isSkeleton = false
        }
    }
}
