//
//  TeamServiceUseCase.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct TeamServiceUseCase {
    var loadServices: @Sendable () async throws -> [TeamServiceEntity] = { [] }
    var loadServiceDetail: @Sendable (_ id: String) async throws -> TeamServiceEntity? = { _ in nil }
    var loadMemberProfile: @Sendable (_ memberID: String) async throws -> MemberProfileEntity? = { _ in nil }
}

extension TeamServiceUseCase: TestDependencyKey {
    static let testValue: TeamServiceUseCase = {
        let services = TeamServiceEntity.dummyList()
        return TeamServiceUseCase(
            loadServices: {
                try await Task.sleep(for: .milliseconds(400))
                return services
            },
            loadServiceDetail: { id in
                try await Task.sleep(for: .milliseconds(250))
                return services.first { $0.id == id } ?? services.first
            },
            loadMemberProfile: { _ in
                try await Task.sleep(for: .milliseconds(250))
                return MemberProfileEntity.dummy()
            }
        )
    }()
}

// API 미정 상태 임시 처리: liveValue를 testValue로 위임해 더미 데이터로 동작.
// API 합의 후 Repository/Response DTO를 도입하면서 별도 LiveKey로 교체 예정.
extension TeamServiceUseCase: DependencyKey {
    static let liveValue: TeamServiceUseCase = .testValue
}
