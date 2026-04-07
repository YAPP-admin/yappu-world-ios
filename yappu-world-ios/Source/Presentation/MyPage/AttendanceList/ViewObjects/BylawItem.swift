//
//  BylawItem.swift
//  yappu-world-ios
//
//  Created by 김도연 on 4/8/26.
//

import Foundation
import SwiftUI

struct BylawItem {
    let text: String
    let boldParts: [String]

    init(_ text: String, bold boldParts: [String] = []) {
        self.text = text
        self.boldParts = boldParts
    }
}

extension BylawItem {
    static let attendanceBylaws: [BylawItem] = [
        BylawItem("모든 회원은 기본점수 100점부터 시작됩니다."),
        BylawItem("출석 점수 70점 이상인 경우, 활동기간을 이수한 것으로 인정됩니다."),
        BylawItem("지각은 10점, 무단 결석은 20점 감점입니다.", bold: ["10점", "20점"]),
        BylawItem("세션 시작 후 10분이 지난 시점부터 2시간 후까지 지각으로 처리합니다. 이후는 결석과 동일하게 처리합니다."),
        BylawItem("결석 사유가 집안의 경조사와 같은 특수한 경우, 회장과 운영진의 회의를 통해 최대 기수별 1회까지 출석을 인정합니다."),
        BylawItem("출석 점수 0점 이하는 제명대상자로 선정됩니다.")
    ]
}
