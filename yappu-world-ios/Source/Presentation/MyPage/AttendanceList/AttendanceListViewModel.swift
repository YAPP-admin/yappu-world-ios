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
    
    var isNotActive: Bool = false
    var statistic: AttendanceStatisticEntity? = nil
    var histories: [ScheduleEntity] = [.dummy(), .dummy(), .dummy()]
    
    init() { }
    
    
    func onTask() async {
        do {
            let statistic = try await useCase.loadStatistics()
            let histories = try await useCase.loadHistory()
            let sessions = try await sessionUseCase.loadSessionsBySession()?.data.sessions
                .map { $0.toEntity() }
            
            await MainActor.run {
                if statistic?.isSuccess ?? false {
                    self.statistic = statistic?.data.toEntity()
                }
                
                if histories?.isSuccess ?? false {
                    self.histories = histories?.data.histories.map { history in
                        let session = sessions?.first { $0.id == history.sessionId }
                        return history.toEntity(
                            time: session?.time,
                            endTime: session?.endTime
                        )
                    } ?? []
                }
                
                isInit = false
            }
            
        } catch {
            if let error = error as? YPError {
                switch error.errorCode {
                case "ATD_2002", "USR_0006":  // ATD_2002: 활성화 된 기수가 없어서 출석 관련 처리가 불가합니다.
                    isNotActive = true        // USR_0006: 해당 세대의 활동 정보를 가진 유저를 찾을 수 없습니다.
                default:
                    isNotActive = true
                    YPGlobalPopupManager.shared.show()
                }
            }
        }
    }
    
    func backButton() {
        navigation.pop()
    }
    
}
