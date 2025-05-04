//
//  SchedulesReqeust.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/20/25.
//

import Foundation

struct SchedulesReqeust: Encodable {
    let year: Int
    let month: Int
    let from: String?
    let to: String?
    
    init(year: Int, month: Int, from: String? = nil, to: String? = nil) {
        self.year = year
        self.month = month
        self.from = from
        self.to = to
    }
}
