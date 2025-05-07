//
//  HomeRepository+LiveKey.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import Foundation
import Dependencies

extension HomeRepository: DependencyKey {
    static var liveValue: HomeRepository = {
        
        let networkClient = NetworkClient<HomeEndPoint>.buildNonToken()
        let tokenNetworkClient = NetworkClient<HomeEndPoint>.build()
        
        return HomeRepository(
            loadProfile: {
                let response: ProfileResponse = try await tokenNetworkClient.request(endpoint: .loadProfile)
                    .response()
                
                return response
            }, loadUpcomingSession: {
                let response: UpcomingSessionResponse = try await tokenNetworkClient.request(endpoint: .loadUpcomingSession)
                    .response()
                
                return response
            }, fetchAttendance: { model in
                let request = AttendanceRequest(sessionId: model.sessionId, attendanceCode: model.attendanceCode)

                do {
                    
                    let _: EmptyResponse = try await tokenNetworkClient
                        .request(endpoint: .fetchAttendance(request))
                        .response()

                    return .init(message: nil, isSuccess: true, errorCode: nil)
                    
                } catch {
                    let response: AttendanceResponse = try await tokenNetworkClient
                        .request(endpoint: .fetchAttendance(request))
                        .response()
                    
                    return response
                }
            })
    }()
}
