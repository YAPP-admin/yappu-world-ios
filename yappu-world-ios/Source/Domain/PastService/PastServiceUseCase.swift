//
//  PastServiceUseCase.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
struct PastServiceUseCase {
    var loadServices: @Sendable () async throws -> [PastServiceEntity] = { [] }
    var loadServiceDetail: @Sendable (_ id: String) async throws -> PastServiceEntity? = { _ in nil }
    var loadMemberProfile: @Sendable (_ memberID: String) async throws -> MemberProfileEntity? = { _ in nil }
}

extension PastServiceUseCase: TestDependencyKey {
    static let testValue: PastServiceUseCase = {
        let services = PastServiceEntity.dummyList()
        return PastServiceUseCase(
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
