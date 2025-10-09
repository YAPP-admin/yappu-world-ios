//
//  OperationRepository+LiveKey.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/4/25.
//

import Foundation
import Dependencies

extension OperationRepository: DependencyKey {
    static var liveValue: OperationRepository = {
        let networkClient = NetworkClient<OperationEndPoint>.buildNonToken()
        
        return OperationRepository(
            loadPositions: {
                do {
                    let response: DefaultResponse<OperationPositionsResponse>? = try await networkClient.request(endpoint: .loadPositions)
                        .response()
                    return response
                } catch {
                    return .init(data: .init(positions: []), isSuccess: false)
                }
            },
            loadUsageInquiry: {
                do {
                    let response: DefaultResponse<OperationLinkResponse>? = try await networkClient.request(endpoint: .loadUsageInquiry)
                        .response()
                    return response
                } catch {
                    return .init(data: .init(link: ""), isSuccess: false)
                }
            },
            loadTermsOfService: {
                do {
                    let response: DefaultResponse<OperationLinkResponse>? = try await networkClient.request(endpoint: .loadTermsOfService)
                        .response()
                    
                    return response
                } catch {
                    return .init(data: .init(link: ""), isSuccess: false)
                }
            },
            loadPrivacyPolicy: {
                do {
                    let response: DefaultResponse<OperationLinkResponse>? = try await networkClient.request(endpoint: .loadPrivacyPolicy)
                        .response()
                    
                    return response
                } catch {
                    return .init(data: .init(link: ""), isSuccess: false)
                }
            },
            loadForceUpdate: { model in
                do {
                    let response: DefaultResponse<OperationForceUpdateResponse>? = try await networkClient.request(endpoint: .loadForceUpdate(model))
                        .response()
                    
                    return response
                } catch {
                    return .init(data: .init(needForceUpdate: false), isSuccess: false)
                }
            },
            loadActiveGeneration: {
                do {
                    let response: DefaultResponse<OperationActiveGenerationResponse>? = try await networkClient.request(endpoint: .loadActiveGeneration)
                        .response()
                    
                    return response
                } catch {
                    return .init(data: .init(isActive: false, generation: 26), isSuccess: false)
                }
            }
        )
    }()
}
