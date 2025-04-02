//
//  HeaderInterceptor.swift
//  FullCarKit
//
//  Created by 한상진 on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation
import Dependencies

final class ErrorInterceptor: NetworkInterceptor {
    static let shared = ErrorInterceptor()
    
    private init() { }
    
    func adapt(urlRequest: URLRequest, options: NetworkRequestOptions) async throws -> URLRequest {
        return urlRequest
    }
    
    func retry(
        urlRequest: URLRequest, 
        response: URLResponse?, 
        data: Data?, 
        with error: Error, 
        options: NetworkRequestOptions
    ) async -> (URLRequest, RetryResult) {
        let mappedError = map(error: error, response: response, data: data)
        // sessionError일 경우 kickout 해야하지만 현재 미구현
        return (urlRequest, .doNotRetry(with: mappedError))
    }
}

extension ErrorInterceptor {
    private func map(error: Error, response: URLResponse?, data: Data?) -> Error {
        if (error as NSError).code == NSURLErrorCancelled { return NetworkError.Response.cancelled }
        if let networkError = error as? NetworkError { return networkError }
        guard let httpResponse = response as? HTTPURLResponse else { return NetworkError.Response.unhandled(error: error) }
        let statusCode = httpResponse.statusCode
        // if let sessionError = SessionError(statusCode, error)
        return NetworkError.Response(statusCode: statusCode, error: error)
    }
}

final class TokenInterceptor: NetworkInterceptor {
    static let shared = TokenInterceptor()
    
    private init() { }
    
    func adapt(urlRequest: URLRequest, options: NetworkRequestOptions) async throws -> URLRequest {
        let request = try await addToken(to: urlRequest, for: options)
        return request
    }
    
    func retry(
        urlRequest: URLRequest, 
        response: URLResponse?, 
        data: Data?, 
        with error: Error, 
        options: NetworkRequestOptions
    ) async -> (URLRequest, RetryResult) {
        @Dependency(\.tokenStorage) var tokenStorage
        
        do {
            let oldCredential = try await tokenStorage.loadToken()
            let newCredential = try await refresh(credential: oldCredential)
            await tokenStorage.save(token: newCredential)
            
            let request = try await addToken(to: urlRequest, for: options)
            return (request, .retry)
        } catch {
            return (urlRequest, .doNotRetry(with: error))
        }
    }
}

extension TokenInterceptor {
    private func addToken(to urlRequest: URLRequest, for options: NetworkRequestOptions) async throws -> URLRequest {
        @Dependency(\.tokenStorage) var tokenStorage

        var urlRequest = urlRequest
        let credential = try await tokenStorage.loadToken()

        urlRequest.setHeaders([.authorization("Bearer \(credential.accessToken)")])

        return urlRequest
    }

    private func refresh(credential: AuthToken) async throws -> AuthToken {
        let networkClient = NetworkClient<AuthEndPoint>.buildNonToken()
        
        let response: AuthResponse = try await networkClient
            .request(endpoint: .reissueToken(credential))
            .response()
        
        let newCredential: AuthToken = .init(
            accessToken: response.data?.accessToken ?? "",
            refreshToken: response.data?.refreshToken ?? ""
        )

        return newCredential
    }
}


final class HeaderInterceptor: NetworkInterceptor {
    static let shared = HeaderInterceptor()
    
    private init() { }
    
    func adapt(urlRequest: URLRequest, options: NetworkRequestOptions) async throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setHeaders(Self.headers)
        return urlRequest
    }
    
    func retry(
        urlRequest: URLRequest, 
        response: URLResponse?, 
        data: Data?, 
        with error: Error, 
        options: NetworkRequestOptions
    ) async -> (URLRequest, RetryResult) {
        return (urlRequest, .doNotRetry(with: error))
    }
}

extension HeaderInterceptor {
    static var headers: [Header] = {
        var headers: [Header] = .init()
        headers.append(.contentType(value: "application/json"))
        return headers
    }()
}

extension HTTPURLResponse {
    fileprivate func isUnAuthorizedStatus() -> Bool {
        return 401 == statusCode
    }
}
