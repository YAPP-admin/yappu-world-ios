//
//  ParameterEncoding.swift
//  todayMovie
//
//  Created by 한상진 on 11/20/23.
//

import Foundation

public protocol ParameterEncodable {
    func encode(
        request: URLRequest,
        with parameters: Parameters?
    ) throws -> URLRequest
}

public struct URLEncoding: ParameterEncodable {
    public func encode(
        request: URLRequest,
        with parameters: Parameters?
    ) throws -> URLRequest {
        var request = request
        guard let parameters else { return request }
        guard let url = request.url else {
            throw NetworkError.parameterEnocdingFailed(.missingURL)
        }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = parameters.compactMap { key, value in
                return URLQueryItem(name: key, value: "\(value)")
            }
            request.url = urlComponents.url
        }
#if DEBUG
        print("parameters: ", terminator: "")
        dump(parameters)
#endif
        return request
    }
}

public struct JSONEncoding: ParameterEncodable {
    public func encode(
        request: URLRequest,
        with parameters: Parameters?
    ) throws -> URLRequest {
        var request = request
        guard let parameters else { return request }
        guard JSONSerialization.isValidJSONObject(parameters) else {
            throw NetworkError.parameterEnocdingFailed(.invalidJSON)
        }
        do {
#if DEBUG
            let data: Data = try JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted])
            print("body: ", terminator: "")
            print(String(data: data, encoding: .utf8) ?? "nil")
#else
            let data: Data = try JSONSerialization.data(withJSONObject: parameters)
#endif
            request.httpBody = data
        }
        catch {
            throw NetworkError.parameterEnocdingFailed(.jsonEncodingFailed)
        }
        return request
    }
}
