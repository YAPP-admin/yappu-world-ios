//
//  AuthEndPoint.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/2/25.
//

import Foundation

enum AuthEndPoint: URLRequestConfigurable {
    case fetchSignUp(_ model: SignUpRequest)
    case reissueToken(_ model: AuthToken)
    case fetchLogin(_ model: LoginRequest)
    case fetchCheckEmail(_ model: CheckEmailRequest)
    
    var url: any URLConvertible {
        return String.baseURL
    }
    
    var path: String? {
        switch self {
        case .fetchSignUp: return "/v1/auth/sign-up"
        case .reissueToken: return "/v1/auth/reissue-token"
        case .fetchLogin: return "/v1/auth/login"
        case .fetchCheckEmail: return "/v1/auth/check-email"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchSignUp,
             .reissueToken,
             .fetchLogin,
             .fetchCheckEmail:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .fetchSignUp(model):
            return .makeParameters(model)
        case let .reissueToken(model):
            return .makeParameters(model)
        case let .fetchLogin(model):
            return .makeParameters(model)
        case let .fetchCheckEmail(model):
            return .makeParameters(model)
        }
    }
    
    var headers: [Header]? {
        switch self {
        case .fetchSignUp,
             .reissueToken,
             .fetchLogin,
             .fetchCheckEmail:
            return nil
        }
    }
    
    var encoder: any ParameterEncodable {
        switch self {
        case .fetchSignUp,
             .reissueToken,
             .fetchLogin,
             .fetchCheckEmail:
            return JSONEncoding()
        }
    }
    
    
}
