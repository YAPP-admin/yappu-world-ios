//
//  TeamServiceEndPoint.swift
//  yappu-world-ios
//
//  Created by 김도형 on 6/2/26.
//

import Foundation

enum TeamServiceEndPoint: URLRequestConfigurable {
    /// 역대 서비스 목록 (커서 페이지네이션 + generation/platform 필터)
    case loadServices(_ request: TeamServiceRequest)
    /// 역대 서비스 상세
    case loadServiceDetail(_ serviceId: String)
    /// 공개 회원 프로필
    case loadUserProfile(_ userId: String)

    var url: any URLConvertible {
        return String.baseURL
    }

    var path: String? {
        switch self {
        case .loadServices:
            return "/v1/team-services"
        case let .loadServiceDetail(serviceId):
            return "/v1/team-services/\(serviceId)"
        case let .loadUserProfile(userId):
            return "/v1/users/\(userId)/profile"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .loadServices, .loadServiceDetail, .loadUserProfile:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .loadServices(request):
            return .makeNotNilParameters(request)
        case .loadServiceDetail, .loadUserProfile:
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
        case .loadServices:
            return URLEncoding()
        case .loadServiceDetail, .loadUserProfile:
            return JSONEncoding()
        }
    }
}
