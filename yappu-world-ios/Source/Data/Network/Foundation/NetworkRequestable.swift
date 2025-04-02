//
//  DataRequest.swift
//  FullCarKit
//
//  Created by 한상진 on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation

public struct NetworkResponse {
    public let data: Data?
    public let response: URLResponse?
    public let error: Error?
    
    public init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
}


public protocol NetworkRequestable {
    var session: URLSession { get }
    var task: URLSessionTask? { get }
    var options: NetworkRequestOptions { get }
    var endpoint: URLRequestConfigurable { get }
    var interceptors: [NetworkInterceptor] { get }
    
    func response<Model: Decodable>(with decoder: JSONDecoder) async throws -> Model
    
    func adapt(request: URLRequest) async throws -> URLRequest
    func retry(
        request: URLRequest,
        response: URLResponse,
        data: Data?,
        error: Error
    ) async -> (URLRequest, RetryResult)
    func decode<Model: Decodable>(with decoder: JSONDecoder, response: NetworkResponse) throws -> Model
    func validate(response: NetworkResponse) throws
    func cancel() -> Self
} 

public extension NetworkRequestable {
    func adapt(request: URLRequest) async throws -> URLRequest {
        var urlRequest = request
        for interceptor in interceptors {
            urlRequest = try await interceptor.adapt(urlRequest: urlRequest, options: options)
        }
        return urlRequest
    }

    func retry(
        request: URLRequest,
        response: URLResponse,
        data: Data?,
        error: Error
    ) async -> (URLRequest, RetryResult) {
        var urlRequest = request
        var retryResult = RetryResult.doNotRetry(with: error)
        
        for interceptor in interceptors {
            if case RetryResult.doNotRetry(let error) = retryResult {
                (urlRequest, retryResult) = await interceptor.retry(
                    urlRequest: urlRequest, 
                    response: response, 
                    data: data, 
                    with: error, 
                    options: options
                )
            } else {
                return (urlRequest, RetryResult.retry)
            }
        }
        return (urlRequest, retryResult)    
    }
    
    func decode<Model: Decodable>(
        with decoder: JSONDecoder,
        response: NetworkResponse
    ) throws -> Model {
        if let data = response.data {
            
            if let httpResponse = response.response as? HTTPURLResponse,
               httpResponse.statusCode == 204,
               Model.self == EmptyResponse.self {
                // EmptyResponse 타입으로 디코딩하려는 경우 빈 객체 반환
                return EmptyResponse() as! Model
            }
            
            #if DEBUG
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            
            print("body: \(String(data: jsonData, encoding: .utf8) ?? "nil")")
            #endif
            if let success = try? decoder.decode(Model.self, from: data) {
                return success
            } else {
                throw NetworkError.Decoding.failed
            }
        } else {
            throw NetworkError.Decoding.dataIsNil
        }
    }
    
    func validate(response: NetworkResponse) throws {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            throw NetworkError.Response.unhandled(error: response.error)
        }
        
        guard httpResponse.isValidateStatus() else {
            if let error: YPError = try? decode(
                with: JSONDecoder(),
                response: response
            ) {
                print("receive error data\n")
                dump(error)
                throw error
            }
            
            throw NetworkError.Response.invalidStatusCode(code: httpResponse.statusCode)
        }
    }
    
    @discardableResult
    func cancel() -> Self {
        task?.cancel()
        return self
    }
}

// 빈 응답을 위한 타입
struct EmptyResponse: Decodable {}

extension HTTPURLResponse {
    fileprivate func isValidateStatus() -> Bool {
        return (200..<300).contains(statusCode)
    }
}
