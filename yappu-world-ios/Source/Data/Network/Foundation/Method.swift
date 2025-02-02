//
//  JHRequest.swift
//  todayMovie
//
//  Created by 한상진 on 11/20/23.
//

import Foundation

public typealias Parameters = [String: Any]

extension Parameters {
    static func makeParameters(_ model: Any) -> Parameters {
        var params: Parameters = [:]
        for child in Mirror(reflecting: model).children {
            guard let label = child.label else { continue }
            params[label] = child.value
        }
        return params
    }
}

@frozen public enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
