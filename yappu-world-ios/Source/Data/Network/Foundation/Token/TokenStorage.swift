//
//  TokenStorage.swift
//  FullCarKit
//
//  Created by Sunny on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation
import Dependencies

actor TokenStorage {
    static let key = "accountCredential"

    enum TokenStorageError: Error {
        case accountCredentialNil
    }

    func save(token: AuthToken) {
        let encoder = JSONEncoder()
        guard let token = try? encoder.encode(token) else { return }

        deleteToken()

        Keychain.shared.set(token, forKey: TokenStorage.key)
    }

    func loadToken() throws -> AuthToken {
        let decoder = JSONDecoder()
        guard let data = Keychain.shared.getData(TokenStorage.key),
              let credential = try? decoder.decode(AuthToken.self, from: data) else {
            throw TokenStorageError.accountCredentialNil
        }

        return credential
    }

    func deleteToken() {
        Keychain.shared.delete(TokenStorage.key)
    }
}

extension DependencyValues {
    var tokenStorage: TokenStorage {
        get { self[TokenStorage.self] }
        set { self[TokenStorage.self] = newValue }
    }
}

extension TokenStorage: DependencyKey {
    static var liveValue: TokenStorage = .init()
}
