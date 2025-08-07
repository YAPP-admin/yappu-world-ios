//
//  SessionScheduleViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@Observable
class SessionScheduleViewModel {
    @ObservationIgnored
    @Dependency(SessionUseCase.self)
    private var useCase
    
    var isInit: Bool = false
    
    var sessions: [ScheduleEntity] = []
    var todaySession: [ScheduleEntity] = []
    
    init() {
        
    }
    
    func onTask(refresh: Bool = false) async {
        
        if refresh {
            await MainActor.run {
                isInit = false
                sessions = []
            }
        }
        
        guard isInit.not() else { return }
        
        do {
            let datas = try await useCase.loadSessionsBySession()
            
            if datas?.isSuccess ?? false {
                guard let data = datas?.data else { return }
                
                await MainActor.run {
                    sessions = data.sessions.map { $0.toEntity() }.sorted(by: {
                        // 상태 우선순위 정의
                        if $0.scheduleProgressPhase != $1.scheduleProgressPhase {
                            return $0.scheduleProgressPhase?.sortOrder ?? Int.max < $1.scheduleProgressPhase?.sortOrder ?? Int.max
                        }
                        
                        // 시작일 비교(yyyy-mm-dd)
                        if $0.date != $1.date {
                            return $0.date ?? "" < $1.date ?? ""
                        }
                        
                        // 시작시간 비교(hh:mm:ss)
                        if $0.time != $1.time {
                            return $0.time ?? "" < $1.time ?? ""
                        }
                        
                        // 시작일 비교(yyyy-mm-dd)
                        if $0.endDate != $1.endDate {
                            return $0.endDate ?? "" < $1.endDate ?? ""
                        }
                        
                        // 종료시간 비교(hh:mm:ss)
                        if $0.endTime != $1.endTime {
                            return $0.endTime ?? "" < $1.endTime ?? ""
                        }
                        
                        // ID 비교
                        return $0.id < $1.id
                    })
                    
                    
                    // TODAY, ONGOING 상태의 세션들을 노출
                    self.todaySession = sessions.filter { $0.scheduleProgressPhase == .today || $0.scheduleProgressPhase == .ongoing }
                    self.todaySession = [sessions.first!]
                    
                    
                    isInit = true
                }
            }
        } catch {
            print("error", error.localizedDescription)
            // Error Catch
            isInit = true
        }
    }
}
