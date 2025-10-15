//
//  SessionEndPoint.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation

enum SessionEndPoint: URLRequestConfigurable {
    
    case loadSessionsByHome(_ model: SessionsRequest)
    case loadSessionsBySession
    case detail(sessionId: String)
    
    var url: any URLConvertible {
        return String.baseURL
    }
    
    var path: String? {
        switch self {
        case .loadSessionsByHome: return "/v2/sessions"
        case .loadSessionsBySession: return "/v1/active-generation/sessions"
        case let .detail(sessionId):
            return "/v1/sessions/\(sessionId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loadSessionsByHome,
             .loadSessionsBySession,
             .detail:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .loadSessionsByHome(model):
            return .makeParameters(model)
        case .loadSessionsBySession:
            return nil
        case .detail:
            return nil
        }
    }
    
    var headers: [Header]? {
        switch self {
        default: nil
        }
    }
    
    var encoder: any ParameterEncodable {
        switch self {
        case .loadSessionsByHome, .loadSessionsBySession: return URLEncoding()
        case .detail: return URLEncoding()
        }
    }
}
