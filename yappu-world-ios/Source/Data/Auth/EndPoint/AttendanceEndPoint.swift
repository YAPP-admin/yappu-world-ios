//
//  AttendanceEndPoint.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import Foundation

enum AttendanceEndPoint: URLRequestConfigurable {
    
    case loadStatistics
    case loadHistory
    
    var url: any URLConvertible {
        return String.baseURL
    }
    
    var path: String? {
        switch self {
        case .loadStatistics: "/v1/attendances/statistics"
        case .loadHistory: "/v1/attendances/history"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loadHistory, .loadStatistics:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .loadStatistics, .loadHistory: nil
        }
    }
    
    var headers: [Header]? {
        switch self {
        default: nil
        }
    }
    
    var encoder: any ParameterEncodable {
        switch self {
        case .loadStatistics, .loadHistory: return URLEncoding()
        //default: return JSONEncoding()
        }
    }
}
