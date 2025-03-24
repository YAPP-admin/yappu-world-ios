//
//  NoticeDetailViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@Observable
class NoticeDetailViewModel {
    @ObservationIgnored
    @Dependency(Navigation<HomePath>.self)
    var navigation
    
    @ObservationIgnored
    @Dependency(\.userStorage)
    private var userStorage
    
    @ObservationIgnored
    @Dependency(NoticeUseCase.self)
    private var useCase
    
    var id: String
    
    var noticeEntity: NoticeEntity = .dummy()
    
    init(id: String) {
        self.id = id
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}

extension NoticeDetailViewModel {
    func onAppear() async throws {
        let value = try await useCase.loadNoticeDetail(id: id)
        
        if let value = value {
            noticeEntity = value.data.toEntity()
        }
        
    }
}
