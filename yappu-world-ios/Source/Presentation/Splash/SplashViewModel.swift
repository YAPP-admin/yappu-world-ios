//
//  SplashViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/28/25.
//

import Observation

import Dependencies

@Observable
final class SplashViewModel {
    @ObservationIgnored
    @Dependency(Router<Flow>.self)
    private var flowRouter
    
    @ObservationIgnored
    @Dependency(SplashUseCase.self)
    private var useCase
    
    @ObservationIgnored
    @Dependency(\.userStorage)
    private var userStorage
    
    func onTask() async {
        do {
            let response = try await useCase.reissueToken()
            if response {
                let profile = try await useCase.loadProfile()
                await userStorage.save(user: profile.data)
                flowRouter.switch(.home)
            } else {
                flowRouter.switch(.login)
            }
        } catch {
            flowRouter.switch(.login)
        }
    }
}
