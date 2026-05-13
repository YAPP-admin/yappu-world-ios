//
//  MemberProfileViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation
import Observation
import Dependencies

@Observable
final class MemberProfileViewModel {
    @ObservationIgnored
    @Dependency(Navigation<TabViewGlobalPath>.self)
    private var navigation

    @ObservationIgnored
    @Dependency(PastServiceUseCase.self)
    private var useCase

    let memberID: String
    var member: MemberProfileEntity?

    var isLoading: Bool { member == nil }

    var sortedActivities: [MemberActivityEntity] {
        (member?.activities ?? []).sorted { $0.generation > $1.generation }
    }

    init(memberID: String) {
        self.memberID = memberID
    }

    @Sendable
    func onTask() async {
        do {
            let profile = try await useCase.loadMemberProfile(memberID)
            await MainActor.run {
                self.member = profile
            }
        } catch {
            await MainActor.run {
                self.member = nil
            }
        }
    }

    func clickBackButton() {
        navigation.pop()
    }

    func clickSnippet(_ serviceId: String) {
        navigation.push(.pastServiceDetail(id: serviceId))
    }
}
