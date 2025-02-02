//
//  URLRequestConfigurable.swift
//  FullCarKit
//
//  Created by 한상진 on 12/18/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation

public protocol URLRequestConfigurable {
    var url: URLConvertible { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: [Header]? { get }
    var encoder: ParameterEncodable { get }
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConfigurable {
    public func asURLRequest() throws -> URLRequest {
        var request = try URLRequest(url: url.asURL())
        if let path { request.url?.append(path: path) }
        if let headers { request.setHeaders(headers) }
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers?.dictionary

        #if DEBUG
        print("[ℹ️] NETWORK -> request:")
        print("""
        method: \(method.rawValue),
        url: \(url)\(path ?? ""),
        """
        )
        print("headers: ", terminator: "")
        print("[")
        for header in headers ?? [] {
            print("  \(header.key): \(header.value),")
        }
        print("],")
        #endif

        return try encoder.encode(request: request, with: parameters)
    }
}
