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
            let datas = try await useCase.loadSessions()
            
            if datas?.isSuccess ?? false {
                guard let data = datas?.data else { return }
                
                await MainActor.run {
                    sessions = data.sessions.map { $0.toEntity() }
                    
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
