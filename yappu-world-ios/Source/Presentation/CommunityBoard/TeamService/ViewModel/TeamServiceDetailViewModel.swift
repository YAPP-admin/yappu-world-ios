//
//  TeamServiceDetailViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation
import Observation
import Dependencies

@Observable
final class TeamServiceDetailViewModel {
    @ObservationIgnored
    @Dependency(Navigation<TabViewGlobalPath>.self)
    private var navigation

    @ObservationIgnored
    @Dependency(TeamServiceUseCase.self)
    private var useCase

    let id: String
    var service: TeamServiceEntity?

    var isLoading: Bool { service == nil }

    /// 직군별로 그룹핑된 팀원 (displayOrder 기준 정렬)
    var groupedTeam: [(role: Position, members: [TeamServiceTeamMember])] {
        guard let service else { return [] }
        let grouped = Dictionary(grouping: service.teamMembers, by: { $0.position })
        return grouped
            .map { (role: $0.key, members: $0.value) }
            .sorted { $0.role.displayOrder < $1.role.displayOrder }
    }

    init(id: String) {
        self.id = id
    }

    @Sendable
    func onTask() async {
        do {
            service = try await useCase.loadServiceDetail(id)
        } catch {
            service = nil
        }
    }

    func clickBackButton() {
        navigation.pop()
    }

    func clickLink(_ link: TeamServiceLink) {
        navigation.push(.safari(url: link.url))
    }

    func clickMember(_ memberID: String) {
        navigation.push(.memberProfile(memberID: memberID))
    }
}
