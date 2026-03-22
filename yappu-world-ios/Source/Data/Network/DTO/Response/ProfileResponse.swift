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
    var isSuccess: Bool
}

struct Profile: Codable {
    let id: String
    let name: String
    let role: String
    let activityUnits: [ActivityUnit]
}

extension Profile {
    static func dummy() -> Self {
        return .init(id: "eqwewq23412", name: "Test", role: "관리자", activityUnits: [.init(generation: 20, position: .init(name: "김얍얍", label: "IOS"))])
    }
}

struct ActivityUnit: Codable {
    let generation: Int
    let position: ActivityPosition
}

struct ActivityPosition: Codable {
    let name: String
    let label: String
}


extension ProfileResponse: TestDependencyKey {
    static var testValue: ProfileResponse = {
        return ProfileResponse(data: .init(id: "dsadas", name: "Test", role: "관리자", activityUnits: [.init(generation: 19, position: .init(name: "ㅇ무니", label: "운머ㅏ"))]), isSuccess: true)
    }()
}
