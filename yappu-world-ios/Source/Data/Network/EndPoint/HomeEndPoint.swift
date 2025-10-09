//
//  HomeEndPoint.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import Foundation

enum HomeEndPoint: URLRequestConfigurable {
    case loadProfile
    case loadUpcomingSession
    case fetchAttendance(_ model: AttendanceRequest)
    
    var url: any URLConvertible {
        return String.baseURL
    }
    
    var path: String? {
        switch self {
        case .loadProfile: return "/v1/users/profile"
        case .loadUpcomingSession: return "/v1/sessions/upcoming"
        case .fetchAttendance: return "/v1/attendances"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loadProfile, .loadUpcomingSession:
            return .get
        case .fetchAttendance:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .loadProfile, .loadUpcomingSession:
            return nil
        case let .fetchAttendance(model):
            return .makeParameters(model)
        }
    }
    
    var headers: [Header]? {
        switch self {
        default: return nil
        }
    }
    
    var encoder: any ParameterEncodable {
        switch self {
        case .loadProfile, .loadUpcomingSession: return URLEncoding()
        case .fetchAttendance: return JSONEncoding()
        }
    }
}
