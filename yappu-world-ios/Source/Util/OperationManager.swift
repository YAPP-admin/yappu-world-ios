//
//  OperationManager.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/4/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@Observable
class OperationManager {
    
    @ObservationIgnored
    @Dependency(OperationUseCase.self)
    var useCase
    
    static var 개인정보_처리방침_URL = "https://yapp-workspace.notion.site/fc24f8ba29c34f9eb30eb945c621c1ca?pvs=4"
    
    static var 서비스_이용약관_URL = "https://yapp-workspace.notion.site/48f4eb2ffdd94740979e8a3b37ca260d?pvs=4"
    
    static var 카카오톡_채널_URL = "https://pf.kakao.com/_aGxofd"
    
    static var 이용_문의_URL = "https://www.yapp.co.kr"
    
    static var 기본_규칙_URL = "https://www.yapp.co.kr"
    
    static var 직군_정보: [PositionEntity] = [
        .init(name: "PM", label: "PM"),
        .init(name: "DESIGN", label: "Design"),
        .init(name: "WEB", label: "Web"),
        .init(name: "ANDROID", label: "Android"),
        .init(name: "IOS", label: "iOS"),
        .init(name: "FLUTTER", label: "Flutter"),
        .init(name: "SERVER", label: "Server"),
        .init(name: "STAFF", label: "운영진")
    ]
    
    static var 강제_업데이트_필요_여부: Bool = false
    
    static var 현재_활동_중인_기수: ActiveGenerationEntity? = nil
    
    init() {
        Task { await fetchOperations() }
    }
    
    private func fetchOperations() async {
        do {
            async let usageInquiry = try useCase.loadUsageInquiry()
            async let termsOfServices = try useCase.loadTermsOfService()
            async let privacyPolicy = try useCase.loadPrivacyPolicy()
            async let positions = try useCase.loadPositions()
            async let forceUpdate = try useCase.loadForceUpdate(model: .init(version: Bundle.main.releaseVersionNumber ?? "1.0.0"))
            async let activeGeneration = try useCase.loadActiveGeneration()
            async let baseRule = try useCase.loadBasicRule()

            if try await usageInquiry?.isSuccess ?? false {
                OperationManager.이용_문의_URL = try await usageInquiry?.data.link ?? ""
            }
            
            if try await termsOfServices?.isSuccess ?? false {
                OperationManager.서비스_이용약관_URL = try await termsOfServices?.data.link ?? ""
            }
            
            if try await privacyPolicy?.isSuccess ?? false {
                OperationManager.개인정보_처리방침_URL = try await privacyPolicy?.data.link ?? ""
            }
            
            if try await positions?.isSuccess ?? false {
                OperationManager.직군_정보 = try await positions?.data.positions.map { $0.toEntity() } ?? []
            }
            
            if try await forceUpdate?.isSuccess ?? false {
                OperationManager.강제_업데이트_필요_여부 = try await forceUpdate?.data.needForceUpdate ?? false
            }
            
            if try await activeGeneration?.isSuccess ?? false {
                OperationManager.현재_활동_중인_기수 = try await activeGeneration?.data.toEntity()
                @Dependency(\.userStorage) var userStorage
                await userStorage.saveActiveGeneration(try await activeGeneration?.data.generation)
            }
            
            if try await baseRule?.isSuccess ?? false {
                OperationManager.기본_규칙_URL = try await baseRule?.data.link ?? ""
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
