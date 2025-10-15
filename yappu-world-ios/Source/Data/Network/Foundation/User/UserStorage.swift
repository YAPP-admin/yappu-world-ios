//
//  UserStorage.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/3/25.
//

import Foundation
import Dependencies

actor UserStorage {
    private var user: Profile?
    private var activeGeneration: Int?
    
    func save(user: Profile) async {
        self.user = user
    }
    
    func saveActiveGeneration(_ generation: Int?) async {
        self.activeGeneration = generation
    }
    
    func loadActiveGeneration() async -> Int? {
        return activeGeneration
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
