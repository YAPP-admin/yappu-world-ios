//
//  SchedulesEntity.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import Foundation

struct SchedulesEntity {
    let dates: [ScheduleDateEntity]
}

struct ScheduleDateEntity {
    let date: String
    let schedules: [ScheduleEntity]
}

struct ScheduleEntity: Hashable, Equatable {
    let id: String
    let name: String
    let place: String?
    let date: String?
    let endDate: String?
    let time: String?
    let endTime: String?
    let scheduleType: String?
    let sessionType: String?
    let scheduleProgressPhase: String?
}
