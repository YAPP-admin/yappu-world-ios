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
    var upcommingSession: ScheduleEntity? = nil
    
    init() {
        
    }
    
    func onTask() async {
        
        guard isInit.not() else { return }
        
        do {
            let datas = try await useCase.loadSessions()
            
            if datas?.isSuccess ?? false {
                guard let data = datas?.data else { return }
                
                await MainActor.run {
                    sessions = data.sessions.map { $0.toEntity() }
                    
                    if let upcomming = data.sessions.first(where: { $0.id == data.upcomingSessionId ?? "" }), upcomming.relativeDays == 0 {
                        upcommingSession = upcomming.toEntity()
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
