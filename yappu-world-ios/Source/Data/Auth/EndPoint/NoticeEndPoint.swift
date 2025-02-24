//
//  NoticeEndPoint.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/23/25.
//

import Foundation

enum NoticeEndPoint: URLRequestConfigurable {
    case loadNoticeList(page: Int)
    
    var url: any URLConvertible {
        return String.baseURL
    }
    
    var path: String? {
        switch self {
        case .loadNoticeList: return "/v1/boards"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loadNoticeList:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .loadNoticeList(let page):
            
        }
    }
}
