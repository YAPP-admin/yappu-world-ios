//
//  AllScheduleModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import Foundation

struct AllScheduleModel: Identifiable, Equatable {
    var id: String { yearMonth }
    var yearMonth: String
    var datas: [ScheduleDateEntity]?
    
    static func == (lhs: AllScheduleModel, rhs: AllScheduleModel) -> Bool {
        return lhs.yearMonth == rhs.yearMonth
    }
}
