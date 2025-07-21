//
//  SessionEndPoint.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation

enum SessionEndPoint: URLRequestConfigurable {
    
    case loadSessionsByHome
    case loadSessionsBySession
    
    var url: any URLConvertible {
        return String.baseURL
    }
    
    var path: String? {
        switch self {
        case .loadSessionsByHome: return "/v2/sessions"
        case .loadSessionsBySession: return "/v1/sessions"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loadSessionsByHome, .loadSessionsBySession:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        default: nil
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
        }
    }
}
