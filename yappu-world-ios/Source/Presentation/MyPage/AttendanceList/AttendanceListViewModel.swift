//
//  AttendanceListViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@Observable
class AttendanceListViewModel {
    @ObservationIgnored
    @Dependency(Navigation<TabViewGlobalPath>.self)
    var navigation
    
    @ObservationIgnored
    @Dependency(AttendanceUseCase.self)
    private var useCase
    @ObservationIgnored
    @Dependency(SessionUseCase.self)
    private var sessionUseCase
    
    var isInit: Bool = true
    var isDummy: Bool = false

    var isNotActive: Bool = false
    var statistic: AttendanceStatisticEntity? = nil
    var histories: [AttendanceHistoryEntity] = []

    init() { }

    init(dummy: Bool) {
        self.isDummy = true
        self.isNotActive = false
        self.statistic = .dummy()
        self.histories = AttendanceHistoryEntity.dummies()
        self.isInit = false
    }

    func onTask() async {
        guard !isDummy else { return }
        defer { isInit = false }
        do {
            try await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask { try await self.loadStatistics() }
                group.addTask { try await self.loadHistory() }
                try await group.waitForAll()
            }
        } catch let error as YPError {
            switch error.errorCode {
            case "ATD_2002", "USR_0006", "ATD_2004": break
                // ATD_2002: 활성화 된 기수가 없어서 출석 관련 처리가 불가합니다.
                // USR_0006: 해당 세대의 활동 정보를 가진 유저를 찾을 수 없습니다.
                // ATD_2004: 출석할 수 있는 권한이 없습니다.
            default:
                YPGlobalPopupManager.shared.show()
            }
            isNotActive = true
        } catch {
            YPGlobalPopupManager.shared.show()
            isNotActive = true
        }
    }
    
    func loadStatistics() async throws {
        let statistic = try await useCase.loadStatistics()
        if statistic?.isSuccess ?? false {
            self.statistic = statistic?.data.toEntity()
        }
    }
    
    func loadHistory() async throws {
        let histories = try await useCase.loadHistory()
        if histories?.isSuccess ?? false {
            self.histories = histories?.data.toEntity().histories ?? []
        }
    }
    
    func backButton() {
        navigation.pop()
    }
    
}
