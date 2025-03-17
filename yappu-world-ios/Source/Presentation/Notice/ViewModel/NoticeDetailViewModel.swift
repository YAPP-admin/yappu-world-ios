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
    
    var id: String
    
    var user: Profile? = .dummy()
    var currentUserRole: Member? = nil
    
    var noticeEntity: NoticeEntity = .dummy()
    
    init(id: String) {
        self.id = id
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}

extension NoticeDetailViewModel {
    func onAppear() {
        /*
        Task {
            self.user = await userStorage.loadUser()
        }
         */
        
        if let role = user?.role {
            currentUserRole = Member.convert(role)
        }
    }
    
    func readPercent() -> Int {
        // 읽은 사람의 퍼센트 계산
//        
//        let readCount = noticeEntity.readCount ?? 0
//        let totalMembers = noticeEntity.totalMembers ?? 0
//        
//        guard totalMembers > 0 else { return 0 }
//        
//        let readPercentage = (Double(readCount) / Double(totalMembers)) * 100
//        
//        return Int(readPercentage)
        
        return 0
    }
}
