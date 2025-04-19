//
//  MyPageEndPoint.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import Foundation

enum MyPageEndPoint: URLRequestConfigurable {
    case loadProfile
    case loadPreActivities
    
    var url: any URLConvertible {
        return String.baseURL
    }
    
    var path: String? {
        switch self {
        case .loadProfile: return "/v1/users/profile"
        case .loadPreActivities: return "/v1/users/activity-histories"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loadProfile, .loadPreActivities:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .loadProfile, .loadPreActivities:
            return nil
        }
    }
    
    var headers: [Header]? {
        switch self {
        default: return nil
        }
    }
    
    var encoder: any ParameterEncodable {
        switch self {
        case .loadProfile, .loadPreActivities: return URLEncoding()
        }
    }
}
