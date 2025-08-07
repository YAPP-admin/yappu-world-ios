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
    var upcomingSession: ScheduleEntity? = nil
    
    init() {
        
    }
    
    func onTask(refresh: Bool = false) async {
        
        if refresh {
            await MainActor.run {
                isInit = false
                sessions = []
                upcomingSession = nil
            }
        }
        
        guard isInit.not() else { return }
        
        do {
            let datas = try await useCase.loadSessionsBySession()
            
            if datas?.isSuccess ?? false {
                guard let data = datas?.data else { return }
                
                await MainActor.run {
                    sessions = data.sessions.map { $0.toEntity() }.sorted(by: { before, after in
                        // 상태 우선순위 정의
                        if before.scheduleProgressPhase != after.scheduleProgressPhase {
                            return before.scheduleProgressPhase?.sortOrder ?? Int.max < after.scheduleProgressPhase?.sortOrder ?? Int.max
                        }
                        
                        // 시작일 비교(yyyy-mm-dd)
                        if before.date != after.date {
                            return before.date ?? "" < after.date ?? ""
                        }
                        
                        // 시작시간 비교(hh:mm:ss)
                        if before.time != after.time {
                            return before.time ?? "" < after.time ?? ""
                        }
                        
                        // 시작일 비교(yyyy-mm-dd)
                        if before.endDate != after.endDate {
                            return before.endDate ?? "" < after.endDate ?? ""
                        }
                        
                        // 종료시간 비교(hh:mm:ss)
                        if before.endTime != after.endTime {
                            return before.endTime ?? "" < after.endTime ?? ""
                        }
                        
                        // ID 비교
                        return before.id < after.id
                    })
                    
                    if let upcoming = data.sessions.first(where: { $0.id == data.upcomingSessionId ?? "" }), upcoming.relativeDays == 0 {
                        upcomingSession = upcoming.toEntity()
                    }
                    
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
