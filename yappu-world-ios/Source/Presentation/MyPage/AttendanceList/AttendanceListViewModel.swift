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
    
    var isInit: Bool = true
    
    var statistic: AttendanceStatisticEntity? = nil
    var histories: [ScheduleEntity] = [.dummy(), .dummy(), .dummy()]
    
    init() { }
    
    
    func onTask() async {
        do {
            let statistic = try await useCase.loadStatistics()
            let histories = try await useCase.loadHistory()
            
            
            await MainActor.run {
                if statistic?.isSuccess ?? false {
                    self.statistic = statistic?.data.toEntity()
                }
                
                if histories?.isSuccess ?? false {
                    self.histories = histories?.data.histories.map { $0.toEntity() } ?? []
                }
                
                isInit = false
            }
            
        } catch {
            // Error Catch
        }
    }
    
    func backButton() {
        navigation.pop()
    }
    
}
