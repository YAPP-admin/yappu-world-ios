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
    let startDate: String // 시작 날짜, yyyy-MM-dd
    let startTime: String // 시작 시간
    let startDayOfWeek: String // 시작 요일, ex) 월
    let endDate: String // 종료 날짜, yyyy-MM-dd
    let endTime: String // 종료 시간
    let endDayOfWeek: String // 종료 요일, ex) 월
    let place: String // 장소 이름
    let address: String // 주소
    let latitude: Double // 위도
    let longitude: Double // 경도
    let notices: [NoticeEntity] // 공지사항 목록
    
    struct NoticeEntity: Hashable, Decodable {
        var id: UUID = UUID()
        let notice: Notice
        let writer: Writer
    }
}

extension SessionDetailEntity {
    static func dummy() -> Self {
        return .init(
            id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
            progressPhase: .ongoing,
            title: "개발 세션",
            startDate: "2024-01-01",
            startTime: "12:30:00",
            startDayOfWeek: "월",
            endDate: "2024-01-01",
            endTime: "13:30:00",
            endDayOfWeek: "목",
            place: "강남역",
            address: "서울특별시 강남구 강남대로 지하396 (역삼동 858) 서울특별시 강남구 강남대로 지하396 (역삼동 858)",
            latitude: 37.496486,
            longitude: 127.028361,
            notices: [.init(notice: .init(id: "01995d11-5998-2c76-e56a-c291767fbb33",
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
                      .init(notice: .init(id: "\(Int.random(in: 0...5000000))",
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
                      .init(notice: .init(id: "\(Int.random(in: 0...5000000))",
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
                      .init(notice: .init(id: "\(Int.random(in: 0...5000000))",
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
