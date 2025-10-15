//
//  SessionDetailsEntity.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/19/25.
//

import Foundation

struct SessionDetailsEntity: Hashable, Sendable {
    let id: String
    let progressPhase: ScheduleEntity.ProgressPhase?
    let title: String
    let startDate: String
    let startTime: String
    let startDayOfWeek: String
    let endDate: String
    let endTime: String
    let endDayOfWeek: String
    let place: String
    let address: String
    let latitude: Double
    let longitude: Double
    let notices: [NoticeEntity]
    let relativeDays: Int?
}

