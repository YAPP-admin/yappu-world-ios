//
//  MyPageRepository.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct MyPageRepository {
    var loadProfile: @Sendable() async throws -> ProfileResponse
    var loadPreActivities: @Sendable() async throws -> PreActivityResponse
}

extension MyPageRepository: TestDependencyKey {
    static var testValue: MyPageRepository = {
        @Dependency(MyPageRepository.self)
        var myPageRepository
        
        return MyPageRepository(
            loadProfile: myPageRepository.loadProfile,
            loadPreActivities: myPageRepository.loadPreActivities)
    }()
}
