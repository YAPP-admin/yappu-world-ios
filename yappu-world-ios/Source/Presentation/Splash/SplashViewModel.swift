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
    
    func onTask() async {
        do {
            let response = try await useCase.reissueToken()
            if response {
                flowRouter.switch(.home)
            } else {
                flowRouter.switch(.login)
            }
        } catch {
            flowRouter.switch(.login)
        }
    }
}
