//
//  DataRequest.swift
//  FullCarKit
//
//  Created by 한상진 on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation

public final class DataRequest: NetworkRequestable {
    public let session: URLSession
    public let task: URLSessionTask?
    public let endpoint: URLRequestConfigurable
    public let options: NetworkRequestOptions
    public let interceptors: [NetworkInterceptor]

    public init(
        session: URLSession,
        task: URLSessionTask? = nil,
        endpoint: URLRequestConfigurable,
        options: NetworkRequestOptions = .all,
        interceptors: [NetworkInterceptor]
    ) {
        self.session = session
        self.task = task
        self.endpoint = endpoint
        self.options = options
        self.interceptors = interceptors
    }
    
    @MainActor
    public func response<Model: Decodable>(with decoder: JSONDecoder = .init()) async throws -> Model {
        let initialRequest = try endpoint.asURLRequest()
        let urlRequest = try await adapt(request: initialRequest)
        
        do {
            let response = try await fetchResponse(urlRequest)
            try self.validate(response: response)
            let result: Model = try self.decode(with: decoder, response: response)

            return result
        } catch NetworkError.Session.invalidToken {
            let response = try await handleInvalidToken(urlRequest)
            let result: Model = try self.decode(with: decoder, response: response)
            
            return result
        }
    }

    @MainActor
    public func response() async throws {
        let initialRequest = try endpoint.asURLRequest()
        let urlRequest = try await adapt(request: initialRequest)
        
        do {
            let response = try await fetchResponse(urlRequest)
            try self.validate(response: response)
        } catch NetworkError.Session.invalidToken {
            try await handleInvalidToken(urlRequest)
        }
    }
    
    @discardableResult
    private func handleInvalidToken(_ urlRequest: URLRequest) async throws -> NetworkResponse {
        let (request, _) = await retry(
            request: urlRequest,
            response: nil,
            data: nil,
            error: NetworkError.Session.invalidToken
        )
        let response = try await fetchResponse(request)
        try self.validate(response: response)
        
        return response
    }

    private func fetchResponse(_ urlRequest: URLRequest) async throws -> NetworkResponse {
#if DEBUG
        print("headers: ", terminator: "")
        print("[")
        for header in urlRequest.allHTTPHeaderFields ?? [:] {
            print("  \(header.key): \(header.value),")
        }
        print("],\n")
#endif
        let response = try await dataTask(with: urlRequest)

        #if DEBUG
        print("[ℹ️] NETWORK -> response:")
        if let urlResponse = response.response as? HTTPURLResponse {
            print("url: \(urlResponse.url?.absoluteString ?? "N/A"),")
            print("status code: \(urlResponse.statusCode),")
            print("headers: ", terminator: "")
            let headers = urlResponse.allHeaderFields as? [String: String]
            print("[")
            for header in headers ?? [:] {
                print("  \(header.key): \(header.value),")
            }
            print("],")
        } else {
            print(String(describing: response.response))
        }
        #endif

        return response
    }
    
    private func dataTask(with urlRequest: URLRequest) async throws -> NetworkResponse {
        do {
            let (data, response) = try await session.data(for: urlRequest)
            return NetworkResponse(data: data, response: response, error: nil)
        }
        catch {
            return NetworkResponse(data: nil, response: nil, error: error)
        }
    }
}
