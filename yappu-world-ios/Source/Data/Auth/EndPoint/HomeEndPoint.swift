//
//  HomeEndPoint.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import Foundation

enum HomeEndPoint: URLRequestConfigurable {
    case loadProfile
    
    var url: any URLConvertible {
        return String.baseURL
    }
    
    var path: String? {
        switch self {
        case .loadProfile: return "v1/users/profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loadProfile:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .loadProfile:
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
        case .loadProfile: return URLEncoding()
        }
    }
}
