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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
