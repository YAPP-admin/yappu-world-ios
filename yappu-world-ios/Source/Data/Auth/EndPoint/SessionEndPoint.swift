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
    case loadSessionDetail(_ model: SessionDetailRequest)
    
    var url: any URLConvertible {
        return String.baseURL
    }
    
    var path: String? {
        switch self {
        case .loadSessionsByHome: return "/v2/sessions"
        case .loadSessionsBySession: return "/v1/active-generation/sessions"
        case let .loadSessionDetail(model): return "/v1/sessions/\(model.sessionId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loadSessionsByHome, .loadSessionsBySession, .loadSessionDetail:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .loadSessionsByHome(model):
            return .makeParameters(model)
        case .loadSessionsBySession:
            return nil
        case .loadSessionDetail:
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
        case .loadSessionsByHome, .loadSessionsBySession:
            return URLEncoding()
        case .loadSessionDetail:
            return JSONEncoding()
        }
    }
}
