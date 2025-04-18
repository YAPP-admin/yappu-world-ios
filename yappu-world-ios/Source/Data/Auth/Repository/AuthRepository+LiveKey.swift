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
                
                do {
                    let response: AuthResponse = try await networkClient
                        .request(endpoint: .fetchSignUp(request))
                        .response()
                    
                    if let data = response.data {
                        await tokenStorage.save(token: AuthToken(
                            accessToken: data.accessToken,
                            refreshToken: data.refreshToken
                        ))
                    }
                    
                    return response.toEntity()
                } catch {
                    let _: EmptyResponse = try await networkClient
                        .request(endpoint: .fetchSignUp(request))
                        .response()                    
                    return .init(isSuccess: true, isComplete: false)
                }
            },
            fetchCheckEmail: { model in
                let request = CheckEmailRequest(email: model)
                
                do {
                    let _: EmptyResponse = try await networkClient
                        .request(endpoint: .fetchCheckEmail(request))
                        .response()
                    
                    return .init(message: nil, isSuccess: true, errorCode: nil)
                } catch {
                    
                    let response: CheckEmailResponse = try await networkClient
                        .request(endpoint: .fetchCheckEmail(request))
                        .response()
                    
                    return response
                }
            },
            fetchLogin: { model in
                let request = model.toData()
                let response: AuthResponse = try await networkClient
                    .request(endpoint: .fetchLogin(request))
                    .response()
                if let data = response.data {
                    await tokenStorage.save(token: AuthToken(
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
                    await tokenStorage.deleteToken()
                } catch { throw error }
            },
            reissueToken: {
                let token = try await tokenStorage.loadToken()
                let response: AuthResponse = try await networkClient
                    .request(endpoint: .reissueToken(token))
                    .response()
                
                if let response = response.data {
                    await tokenStorage.save(token: response)
                }
                
                return response.isSuccess
            },
            deleteToken: {
                await tokenStorage.deleteToken()
            }
        )
    }()
}
