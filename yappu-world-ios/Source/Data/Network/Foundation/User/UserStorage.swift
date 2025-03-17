//
//  UserStorage.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/3/25.
//

import Foundation
import Dependencies

actor UserStorage {
    var user: Profile?
    
    func save(user: Profile) async {
        self.user = user
    }
    
    func loadUser() async -> Profile? {
        return user
    }
    
    func deleteUser() async {
        user = nil
    }
}

extension DependencyValues {
    var userStorage: UserStorage {
        get { self[UserStorage.self] }
        set { self[UserStorage.self] = newValue }
    }
}

extension UserStorage: DependencyKey {
    static var liveValue: UserStorage = .init()
}
