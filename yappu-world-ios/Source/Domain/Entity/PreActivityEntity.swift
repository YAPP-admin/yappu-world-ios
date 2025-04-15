//
//  PreActivityEntity.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import Foundation

struct PreActivityEntity: Hashable, Sendable, Codable {
    var id: UUID? = UUID()
    let generation: Int             // 기수
    let position: String            // 직군
    let activityStartDate: String?  // 활동 시작일
    let activityEndDate: String?    // 활동 종료일
}
// MARK: - Dummy Data
extension PreActivityEntity {
    static func dummy() -> Self {
        .init(generation: 20,
              position: "Designer",
              activityStartDate: "2023.11.01",
              activityEndDate: "2024.06.31")
    }
    
    static func dummyList() -> [Self] {
        [.init(generation: 20,
              position: "Designer",
              activityStartDate: "2023.11.01",
              activityEndDate: "2024.06.31"),
         .init(generation: 19,
               position: "PM",
               activityStartDate: "2023.11.01",
               activityEndDate: "2024.06.31"),
         .init(generation: 17,
               position: "Android",
               activityStartDate: "2023.11.01",
               activityEndDate: "2024.06.31"),
         .init(generation: 16,
               position: "iOS",
               activityStartDate: "2023.11.01",
               activityEndDate: "2024.06.31"),
         .init(generation: 15,
               position: "Web",
               activityStartDate: "2023.11.01",
               activityEndDate: "2024.06.31"),
         .init(generation: 14,
               position: "Server",
               activityStartDate: "2023.11.01",
               activityEndDate: "2024.06.31")
         
        ]
    }
}
