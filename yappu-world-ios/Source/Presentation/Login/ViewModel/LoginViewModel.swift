//
//  LoginViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/4/25.
//

import Foundation
import Combine
import SwiftUI
import Dependencies

@Observable
class LoginViewModel {
    // 아직 몰라서 그냥 example에 있는 코드 적어봄
    @ObservationIgnored
    @Dependency(\.continuousClock) var clock
}
