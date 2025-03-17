//
//  AuthRepository+LiveKey.swift
//  yappu-world-ios
//
//  Created by 김도형 on 1/30/25.
//

import Foundation

import Dependencies

extension AuthRepository: DependencyKey {
    static var liveValue: AuthRepository = {
        @Dependency(\.tokenStorage)
        var tokenStorage
        
        let networkClient = NetworkClient<AuthEndPoint>.buildNonToken()
        let tokenNetworkClient = NetworkClient<AuthEndPoint>.build()
        
        return AuthRepository(
            fetchSignUp: { model in
                let request = model.toData()
                let response: AuthResponse = try await networkClient
                    .request(endpoint: .fetchSignUp(request))
                    .response()
                
                if let data = response.data {
                    tokenStorage.save(token: AuthToken(
                        accessToken: data.accessToken,
                        refreshToken: data.refreshToken
                    ))
                }
                
                return response.toEntity()
            },
            fetchCheckEmail: { model in
                let request = CheckEmailRequest(email: model)
                let response: CheckEmailResponse = try await networkClient
                    .request(endpoint: .fetchCheckEmail(request))
                    .response()
                
                return response.isSuccess
            },
            fetchLogin: { model in
                let request = model.toData()
                let response: AuthResponse = try await networkClient
                    .request(endpoint: .fetchLogin(request))
                    .response()
                if let data = response.data {
                    tokenStorage.save(token: AuthToken(
                        accessToken: data.accessToken,
                        refreshToken: data.refreshToken
                    ))
                }
                
                return response.isSuccess
            },
            deleteUser: {
                do {
                    try await tokenNetworkClient
                        .request(endpoint: .deleteUser)
                        .response()
                    tokenStorage.deleteToken()
                } catch { throw error }
            },
            reissueToken: {
                let token = try tokenStorage.loadToken()
                let response: AuthResponse = try await networkClient
                    .request(endpoint: .reissueToken(token))
                    .response()
                
                if let response = response.data {
                    tokenStorage.save(token: response)
                }
                
                return response.isSuccess
            },
            deleteToken: {
                tokenStorage.deleteToken()
            }
        )
    }()
}
