//
//  NetworkClient.swift
//  FullCarKit
//
//  Created by 한상진 on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation

public struct NetworkClient<E: URLRequestConfigurable> {
    private let session: URLSession
    private var interceptors: [NetworkInterceptor]
    
    public init(
        session: URLSession = .main,
        interceptors: [NetworkInterceptor] = []
    ) {
        self.session = session
        self.interceptors = interceptors
    }
    
    public func request(
        endpoint: E,
        interceptor: NetworkInterceptor? = nil
    ) -> DataRequest {
        var interceptors = self.interceptors
        
        if let interceptor {
            interceptors.append(interceptor)
        }
        
        return DataRequest(
            session: session,
            endpoint: endpoint,
            interceptors: interceptors.reversed()
        )
    }
}

public extension URLSession {
    static let main: URLSession = .init(configuration: .default)
}

public extension NetworkClient {
    static func build() -> NetworkClient<E> {
        return NetworkClient<E>(
            session: .main,
            interceptors: [
                HeaderInterceptor.shared,
                TokenInterceptor.shared,
                ErrorInterceptor.shared
            ]
        )
    }
    
    static func buildNonToken() -> NetworkClient<E> {
        NetworkClient<E>(
            session: .main,
            interceptors: [
                HeaderInterceptor.shared,
                ErrorInterceptor.shared
            ]
        )
    }
}
