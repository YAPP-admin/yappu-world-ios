//
//  AlarmsEndPoint.swift
//  yappu-world-ios
//
//  Created by 김도형 on 3/16/25.
//

import Foundation

enum AlarmsEndPoint: URLRequestConfigurable {
    case fetchDevice(_ model: DeviceAlarmRequest)
    case fetchMaster
    case fetchAlarms
    
    var url: any URLConvertible {
        return String.baseURL
    }
    
    var path: String? {
        switch self {
        case .fetchDevice: return "/v1/alarms/device"
        case .fetchMaster: return "/v1/alarms/master"
        case .fetchAlarms: return "/v1/alarms"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchDevice: return .put
        case .fetchMaster: return .patch
        case .fetchAlarms: return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .fetchDevice(model):
            return .makeParameters(model)
        case .fetchMaster,
             .fetchAlarms:
            return nil
        }
    }
    
    var headers: [Header]? {
        switch self {
        case .fetchDevice,
             .fetchMaster,
             .fetchAlarms:
            return nil
        }
    }
    
    var encoder: any ParameterEncodable {
        switch self {
        case .fetchDevice: return JSONEncoding()
        case .fetchMaster,
             .fetchAlarms:
            return URLEncoding()
        }
    }
}
