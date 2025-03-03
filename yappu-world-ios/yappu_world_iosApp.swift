//
//  yappu_world_iosApp.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/4/25.
//

import SwiftUI

@main
struct yappu_world_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate

    init() {
        removeNavigationBarBlur()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

private extension yappu_world_iosApp {
    private func removeNavigationBarBlur() {
        // iOS 15 이상에서 ScrollView 스크롤 시 생기는 블러 효과를 제거
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground() // 투명 배경 설정
        appearance.backgroundEffect = nil // 블러 효과 제거
        appearance.backgroundColor = UIColor.white // 원하는 배경색 설정
        appearance.shadowColor = .clear // 하단 그림자 제거

        // 네비게이션 바의 모든 상태에 적용 (standard, compact, scrollEdge)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
