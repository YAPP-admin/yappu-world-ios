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
    
    var id: String // 세션 Id
    var isSkeleton: Bool = false
    var sessionEntity: SessionDetailEntity? = .dummy()
    var isSelected: YPSectionType = .timeTable
    var sections: [YPSectionEntity] = [
        .init(id: .timeTable, title: "타임테이블"),
        .init(id: .notice, title: "공지사항"),
        .init(id: .attend, title: "출석")
    ]

    init(id: String) {
        self.id = id
        
//        await loadSessionDetail()
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}
// MARK: - Private Async Methods
private extension SessionDetailViewModel {
    // 세션 상세 조회
    func loadSessionDetail() async {
        do {
            let sessionResponse = try await useCase.loadSessionDetail(sessionId: id)

            await MainActor.run {
                if let sessionResponse = sessionResponse {
                    let entity = sessionResponse.data
                    sessionEntity = entity.data
                    
                    if isSkeleton {
                        isSkeleton = false
                    }
                }
            }
        } catch(let error as YPError) {
            errorAction(error)
        } catch {
            print(error)
        }
    }
    
    func errorAction(_ error: YPError) {
        sessionEntity = nil
        isSkeleton = false
//            isLoading = false
    }
}
