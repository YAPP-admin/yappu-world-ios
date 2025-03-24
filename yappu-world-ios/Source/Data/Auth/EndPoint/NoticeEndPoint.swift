//
//  NoticeEndPoint.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/23/25.
//

import Foundation

enum NoticeEndPoint: URLRequestConfigurable {
    case loadNoticeList(_ model: NoticeRequest)
    case loadNoticeDetail(noticeId: String)
    
    var url: any URLConvertible {
        return String.baseURL
    }
    
    var path: String? {
        switch self {
        case .loadNoticeList: return "/v1/posts/notices"
        case .loadNoticeDetail(let notice): return "/v1/posts/notices/\(notice)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loadNoticeList, .loadNoticeDetail:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .loadNoticeList(model):
            return .makeNotNilParameters(model)
        default:
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
        case .loadNoticeList: return URLEncoding()
        default: return JSONEncoding()
        }
    }
}
