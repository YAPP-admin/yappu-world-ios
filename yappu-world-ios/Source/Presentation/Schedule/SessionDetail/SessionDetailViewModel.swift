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
    var sessionEntity: SessionDetailEntity? = .dummy()

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
//            isLoading = false
    }
}
