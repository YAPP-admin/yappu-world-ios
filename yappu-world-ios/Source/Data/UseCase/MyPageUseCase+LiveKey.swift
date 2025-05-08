//
//  MyPageUseCase+LiveKey.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation
import Dependencies

extension MyPageUseCase: DependencyKey {
    static var liveValue: MyPageUseCase = {
        @Dependency(AuthRepository.self)
        var authRepository
        @Dependency(MyPageRepository.self)
        var mypageRepository
        
        return MyPageUseCase(
            loadProfile: mypageRepository.loadProfile,
            loadPreActivities: mypageRepository.loadPreActivities,
            deleteUser: authRepository.deleteUser,
            deleteToken: authRepository.deleteToken
        )
    }()
}
