//
//  AuthTokenResponse.swift
//  FullCarKit
//
//  Created by Sunny on 1/17/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

struct AuthToken: Codable {
    let accessToken: String
    let refreshToken: String
}
