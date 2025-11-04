//
//  SessionDetailEntity.swift
//  yappu-world-ios
//
//  Created by 김건형 on 10/6/25.
//

import Foundation

struct SessionDetailEntity: Decodable {
    let id: String // 세션 ID
    let progressPhase: ScheduleEntity.ProgressPhase // 세션 진행 단계, ex) DONE, ONGOING, TODAY, PENDING
    let title: String // 세션 제목
    let startDateTime: String // 시작 날짜 & 시간, ex) 2025-10-23T04:32:24.291Z
    let startDayOfWeek: String // 시작 요일, ex) 월
    let endDateTime: String // 종료 날짜 & 시간, ex) 2025-10-23T04:32:24.291Z
    let endDayOfWeek: String // 종료 요일, ex) 월
    let place: String // 장소 이름
    let address: String // 주소
    let latitude: Double // 위도
    let longitude: Double // 경도
    let notices: [NoticeEntity] // 공지사항 목록
    
    // 파생 저장 프로퍼티
    var startDate:  String { startDateTime.reformatDate(output: "yyyy. MM. dd (E)") }
    var endDate:    String { endDateTime.reformatDate(output: "yyyy. MM. dd (E)") }
    var startTime:  String { HasStartZeroMinutes ? startDateTime.reformatDate(output: "a h시") : startDateTime.reformatDate(output: "a h시 mm분") }
    var endTime:    String { HasEndZeroMinutes ? endDateTime.reformatDate(output: "a h시") : endDateTime.reformatDate(output: "a h시 mm분") }
    var isSameDate: Bool { startDate == endDate }
    /// 분이 0인지 여부 (start)
    var HasStartZeroMinutes: Bool {
        guard let date = startDateTime.isoDate else { return false }
        return Calendar.autoupdatingCurrent.component(.minute, from: date) == 0
    }

    /// 분이 0인지 여부 (end)
    var HasEndZeroMinutes: Bool {
        guard let date = endDateTime.isoDate else { return false }
        return Calendar.autoupdatingCurrent.component(.minute, from: date) == 0
    }
}
extension SessionDetailEntity {
    static func dummy() -> Self {
        return .init(
            id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
            progressPhase: .ongoing,
            title: "개발 세션",
            startDateTime: "2025-10-23T04:32:24.291Z",
            startDayOfWeek: "월",
            endDateTime: "2025-10-23T06:00:24.291Z",
            endDayOfWeek: "목",
            place: "강남역",
            address: "서울특별시 강남구 강남대로 지하396 (역삼동 858) 서울특별시 강남구 강남대로 지하396 (역삼동 858)",
            latitude: 37.496486,
            longitude: 127.028361,
            notices: [.init(id: "01995d11-5998-2c76-e56a-c291767fbb33",
                           notice: .init(id: "01995d11-5998-2c76-e56a-c291767fbb33",
                                        createdAt: "\(Int.random(in: 0...5000000))",
                                        title: "\(Int.random(in: 0...900000000))",
                                        content: "이게 공지사항",
                                        noticeType: .Notice),
                           writer: .init(id: "\(Int.random(in: 0...5000000))",
                                         name: "\(Int.random(in: 0...5000000))",
                                         activityUnitGeneration: 1,
                                         activityUnitPosition: .init(name: "\(Int.random(in: 0...5000000))",
                                                                     label: "\(Int.random(in: 0...5000000))"
                                                                    ))),
                      .init(id: "\(Int.random(in: 0...5000000))",
                           notice: .init(id: "\(Int.random(in: 0...5000000))",
                                                  createdAt: "\(Int.random(in: 0...5000000))",
                                                  title: "\(Int.random(in: 0...900000000))",
                                                  content: "TestTest",
                                                  noticeType: .Notice),
                                     writer: .init(id: "\(Int.random(in: 0...5000000))",
                                                   name: "\(Int.random(in: 0...5000000))",
                                                   activityUnitGeneration: 1,
                                                   activityUnitPosition: .init(name: "\(Int.random(in: 0...5000000))",
                                                                               label: "\(Int.random(in: 0...5000000))"
                                                                              ))),
                      .init(id: "\(Int.random(in: 0...5000000))",
                           notice: .init(id: "\(Int.random(in: 0...5000000))",
                                                  createdAt: "\(Int.random(in: 0...5000000))",
                                                  title: "\(Int.random(in: 0...900000000))",
                                                  content: "TestTest",
                                                  noticeType: .Notice),
                                     writer: .init(id: "\(Int.random(in: 0...5000000))",
                                                   name: "\(Int.random(in: 0...5000000))",
                                                   activityUnitGeneration: 1,
                                                   activityUnitPosition: .init(name: "\(Int.random(in: 0...5000000))",
                                                                               label: "\(Int.random(in: 0...5000000))"
                                                                              ))),
                      .init(id: "\(Int.random(in: 0...5000000))",
                           notice: .init(id: "\(Int.random(in: 0...5000000))",
                                                  createdAt: "\(Int.random(in: 0...5000000))",
                                                  title: "\(Int.random(in: 0...900000000))",
                                                  content: "TestTest",
                                                  noticeType: .Notice),
                                     writer: .init(id: "\(Int.random(in: 0...5000000))",
                                                   name: "\(Int.random(in: 0...5000000))",
                                                   activityUnitGeneration: 1,
                                                   activityUnitPosition: .init(name: "\(Int.random(in: 0...5000000))",
                                                                               label: "\(Int.random(in: 0...5000000))"
                                                                              )))])
    }
}
