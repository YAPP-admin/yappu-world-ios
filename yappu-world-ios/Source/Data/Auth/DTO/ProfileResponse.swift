//
//  ProfileResponse.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import Foundation
import Dependencies

struct ProfileResponse: Codable {
    var data: Profile
}

struct Profile: Codable {
    let id: String
    let name: String
    let role: String
    let activityUnits: [ActivityUnit]
}

extension Profile {
    static func dummy() -> Self {
        return .init(id: "eqwewq23412", name: "Test", role: "관리자", activityUnits: [])
    }
}

struct ActivityUnit: Codable {
    let generation: Int
    let position: String
}


extension ProfileResponse: TestDependencyKey {
    static var testValue: ProfileResponse = {
        return ProfileResponse(data: .init(id: "dsadas", name: "Test", role: "관리자", activityUnits: [.init(generation: 19, position: "iOS")]))
    }()
}
