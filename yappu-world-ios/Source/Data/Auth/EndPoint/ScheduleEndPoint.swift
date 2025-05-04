//
//  ScheduleEndPoint.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import Foundation

enum ScheduleEndPoint: URLRequestConfigurable {
    
    case loadSchedules(_ model: SchedulesReqeust)
    
    var url: any URLConvertible {
        return String.baseURL
    }
    
    var path: String? {
        switch self {
        case .loadSchedules: return "/v1/schedules"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loadSchedules:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .loadSchedules(let model):
            return .makeNotNilParameters(model)
        }
    }
    
    var headers: [Header]? {
        switch self {
        default: nil
        }
    }
    
    var encoder: any ParameterEncodable {
        switch self {
        case .loadSchedules: return URLEncoding()
        //default: return JSONEncoding()
        }
    }
}
