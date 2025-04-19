//
//  MyPageUseCase.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct MyPageUseCase {
    var loadProfile: @Sendable() async throws -> ProfileResponse
    var loadPreActivities: @Sendable() async throws -> PreActivityResponse
}

extension MyPageUseCase: TestDependencyKey {
    static var testValue: MyPageUseCase = {
        @Dependency(MyPageRepository.self)
        var myPageRepository
        
        return MyPageUseCase(
            loadProfile: myPageRepository.loadProfile,
            loadPreActivities: myPageRepository.loadPreActivities)
    }()
}
