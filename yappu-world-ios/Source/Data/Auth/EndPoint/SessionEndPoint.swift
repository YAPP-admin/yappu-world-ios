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
        case .loadSessionDetail: return "/v1/sessions"
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
        case let .loadSessionDetail(model):
            return .makeParameters(model)
        }
    }
    
    var headers: [Header]? {
        switch self {
        default: nil
        }
    }
    
    var encoder: any ParameterEncodable {
        switch self {
        case .loadSessionsByHome, .loadSessionsBySession, .loadSessionDetail: return URLEncoding()
        }
    }
}
