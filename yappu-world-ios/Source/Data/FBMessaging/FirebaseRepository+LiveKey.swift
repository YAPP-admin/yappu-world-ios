//
//  FirebaseRepository.swift
//  yappu-world-ios
//
//  Created by 김도형 on 3/3/25.
//

import Foundation

import Dependencies

extension FirebaseRepository: DependencyKey {
    static var liveValue = {
        let manager = FirebaseManager()
        
        return FirebaseRepository(
            configureFirebase: manager.configureFirebase,
            updateAPNSToken: manager.updateAPNSToken,
            fetchFCMToken: manager.fetchFCMToken
        )
    }()
}
