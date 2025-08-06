//
//  SessionEndPoint.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation

enum SessionEndPoint: URLRequestConfigurable {
    
    case loadSessions(_ model: SessionsRequest)
    
    var url: any URLConvertible {
        return String.baseURL
    }
    
    var path: String? {
        switch self {
        case .loadSessions: return "/v2/sessions"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loadSessions:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .loadSessions(model):
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
        case .loadSessions: return URLEncoding()
        }
    }
}
