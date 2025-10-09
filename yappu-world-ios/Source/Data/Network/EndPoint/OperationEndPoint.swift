//
//  OperationEndPoint.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/4/25.
//

import Foundation

enum OperationEndPoint: URLRequestConfigurable {
    case loadPositions
    case loadUsageInquiry
    case loadTermsOfService
    case loadPrivacyPolicy
    case loadForceUpdate(_ model: OperationForceUpdateRequest)
    case loadActiveGeneration
    
    var url: any URLConvertible {
        return String.baseURL
    }
    
    var path: String? {
        switch self {
        case .loadPositions: "/v1/operations/positions"
        case .loadUsageInquiry: "/v1/operations/links/usage-inquiry"
        case .loadTermsOfService: "/v1/operations/links/terms-of-service"
        case .loadPrivacyPolicy: "/v1/operations/links/privacy-policy"
        case .loadForceUpdate: "/v1/operations/force-update"
        case .loadActiveGeneration: "/v1/operations/force-update"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .loadForceUpdate(let model):
            return .makeParameters(model)
        default: return nil
        }
    }
    
    var headers: [Header]? {
        switch self {
        default: return nil
        }
    }
    
    var encoder: any ParameterEncodable {
        switch self {
        default: return URLEncoding()
        }
    }
}
