//
//  PreActivitiesViewModel.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@Observable
class PreActivitiesViewModel {
    @ObservationIgnored
    @Dependency(Navigation<MyPagePath>.self)
    var navigation
    
    @ObservationIgnored
    @Dependency(\.userStorage)
    private var userStorage
    
    @ObservationIgnored
    @Dependency(NoticeUseCase.self)
    private var useCase
    
    var activities: [Bool] = []
    var isLoading: Bool = true
    
    // 뒤로가기
    func clickBackButton() {
        navigation.pop()
    }
}
// MARK: - Extension async Methods
extension PreActivitiesViewModel {
    func onTask() async throws {
//        let value = try await useCase.loadNoticeDetail(id: id)
        
//        await MainActor.run {
//            if let value = value {
//                noticeEntity = value.data.toEntity()
//            }
            isLoading = false
//        }
    }
    
    func errorAction() async {
        await MainActor.run {
//            noticeEntity = nil
            isLoading = false
        }
    }
}
