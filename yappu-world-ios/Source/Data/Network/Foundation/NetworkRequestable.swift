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
        response: URLResponse?,
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
        response: URLResponse?,
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
        guard let data = response.data else {
            throw NetworkError.Decoding.dataIsNil
        }

        if let httpResponse = response.response as? HTTPURLResponse,
           (httpResponse.statusCode == 204 || httpResponse.statusCode == 201),
           Model.self == EmptyResponse.self {
            return EmptyResponse() as! Model
        }

        #if DEBUG
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        print("📦 body:\n\(String(data: jsonData, encoding: .utf8) ?? "nil")")
        #endif

        do {
            return try decoder.decode(Model.self, from: data)
        } catch let error as DecodingError {
            // 🔍 여기서 어디서 깨졌는지 자세히 출력
            dumpDecodingError(error)
            throw NetworkError.Decoding.failed(error)   // 아래에서 설명
        } catch {
            print("💥 알 수 없는 디코딩 외 에러: \(error)")
            throw NetworkError.Decoding.failed(error)
        }
    }
    
    func dumpDecodingError(_ error: DecodingError) {
        switch error {
        case .keyNotFound(let key, let context):
            print("❌ keyNotFound: \(key.stringValue)")
            print("   path: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))")
            print("   desc: \(context.debugDescription)")

        case .typeMismatch(let type, let context):
            print("❌ typeMismatch: \(type)")
            print("   path: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))")
            print("   desc: \(context.debugDescription)")

        case .valueNotFound(let type, let context):
            print("❌ valueNotFound: \(type)")
            print("   path: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))")
            print("   desc: \(context.debugDescription)")

        case .dataCorrupted(let context):
            print("❌ dataCorrupted")
            print("   path: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))")
            print("   desc: \(context.debugDescription)")

        @unknown default:
            print("❌ unknown decoding error: \(error)")
        }
    }
    
    func validate(response: NetworkResponse) throws {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            throw NetworkError.Response.unhandled(error: response.error)
        }
        
        guard httpResponse.isValidateStatus() else {
            if httpResponse.statusCode == 401 {
                throw NetworkError.Session.invalidToken
            } else {
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
