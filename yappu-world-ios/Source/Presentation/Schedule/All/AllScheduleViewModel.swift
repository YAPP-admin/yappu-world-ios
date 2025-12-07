//
//  AllScheduleViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/19/25.
//

import Foundation
import SwiftUI
import Dependencies
import DependenciesMacros
import IdentifiedCollections

@Observable
class AllScheduleViewModel {

    @ObservationIgnored
    @Dependency(Navigation<TabViewGlobalPath>.self)
    var navigation

    @ObservationIgnored
    @Dependency(ScheduleUseCase.self)
    private var useCase

    var items: IdentifiedArrayOf<AllScheduleModel> = []

    private let calendar = Calendar.current

    private(set) var currentYearMonth: String = ""

    var scrollPosition: String? {
        didSet {
            print("didSet ScrollPosition", scrollPosition)
            if let scrollPosition {
                currentYearMonth = scrollPosition
            }
        }
    }
    var isLoading: Bool = false

    @ObservationIgnored
    private let taskQueue = SerialTaskQueue()
    
    init() {
        // 현재 날짜로 초기화
        let currentDate = Date()
        currentYearMonth = currentDate.toString(.yearMonth)
        scrollPosition = currentYearMonth

        // 초기 3개월 생성 (-1월, 현재, +1월)
        initCalendar()
    }

    private func initCalendar() {
        var tempItems: IdentifiedArrayOf<AllScheduleModel> = []
        let currentDate = Date()

        // -1월, 현재, +1월만 생성
        for month in -1...1 {
            if let date = calendar.date(byAdding: .month, value: month, to: currentDate) {
                let yearMonth = date.toString(.yearMonth)
                tempItems.append(.init(yearMonth: yearMonth, datas: nil))
            }
        }

        items = tempItems
    }
    
    func nextButtonAction() {
        guard let currentYM = scrollPosition,
              let nextYearMonth = addMonths(to: currentYM, value: 1)
        else { return }

        ensureMonthExists(nextYearMonth)
        scrollPosition = nextYearMonth
    }

    func previousButtonAction() {
        guard let currentYM = scrollPosition,
              let prevYearMonth = addMonths(to: currentYM, value: -1)
        else { return }

        ensureMonthExists(prevYearMonth)
        scrollPosition = prevYearMonth
    }

    /// 페이지 진입 시 호출
    func onPageAppear(_ yearMonth: String) {
        loadDataForYearMonth(yearMonth, refresh: false)
    }

    /// 페이지 새로고침 시 호출
    func onPageRefresh(_ yearMonth: String) {
        loadDataForYearMonth(yearMonth, refresh: true)
    }

    /// 특정 년월 페이지 진입 시, -1월, 해당년월, +1월 데이터 로드
    private func loadDataForYearMonth(_ yearMonth: String, refresh: Bool = false) {
        print("### loadDataForYearMonth called for: \(yearMonth)")

        Task {
            await taskQueue.enqueue { [weak self] in
                guard let self else { return }

                if refresh.not() { self.isLoading = true }
                defer { self.isLoading = false }

                // refresh 모드인 경우 해당 yearMonth의 데이터를 nil로 초기화
                if refresh { self.items[id: yearMonth]?.datas = nil }

                // -1월, 현재, +1월의 items 생성/업데이트
                if let prevYearMonth = self.addMonths(to: yearMonth, value: -1) {
                    self.ensureMonthExists(prevYearMonth)
                }
                self.ensureMonthExists(yearMonth)
                if let nextYearMonth = self.addMonths(to: yearMonth, value: 1) {
                    self.ensureMonthExists(nextYearMonth)
                }

                // 데이터 로드
                do {
                    // 이전 월
                    if let prevYearMonth = self.addMonths(to: yearMonth, value: -1),
                       let prevItem = self.items[id: prevYearMonth],
                       prevItem.datas == nil,
                       let prevDate = self.yearMonthToDate(prevYearMonth) {
                        print("### Loading previous month: \(prevYearMonth)")
                        try await self.loadDataFromServer(yearMonth: prevDate)
                    }

                    // 현재 월
                    if let currentItem = self.items[id: yearMonth],
                       currentItem.datas == nil,
                       let currentDate = self.yearMonthToDate(yearMonth) {
                        print("### Loading current month: \(yearMonth)")
                        try await self.loadDataFromServer(yearMonth: currentDate)
                    }

                    // 다음 월
                    if let nextYearMonth = self.addMonths(to: yearMonth, value: 1),
                       let nextItem = self.items[id: nextYearMonth],
                       nextItem.datas == nil,
                       let nextDate = self.yearMonthToDate(nextYearMonth) {
                        print("### Loading next month: \(nextYearMonth)")
                        try await self.loadDataFromServer(yearMonth: nextDate)
                    }
                } catch {
                    print("### Error in loadDataForYearMonth: \(error)")
                    YPGlobalPopupManager.shared.show()
                }
            }
        }
    }

    /// 년월 문자열을 Date로 변환 (해당 월의 1일)
    private func yearMonthToDate(_ yearMonth: String) -> Date? {
        return "\(yearMonth)-01".toDate(.sessionDate)
    }

    /// 년월 문자열에 개월 수를 더하거나 빼기 (yyyy-MM 형식)
    private func addMonths(to yearMonth: String, value: Int) -> String? {
        guard let date = yearMonthToDate(yearMonth) else { return nil }

        var components = DateComponents()
        components.month = value

        guard let newDate = calendar.date(byAdding: components, to: date) else { return nil }

        return newDate.toString(.yearMonth)
    }
    
    /// 해당 년월이 items에 없으면 추가
    private func ensureMonthExists(_ yearMonth: String) {
        guard let currentYearMonth = scrollPosition else { return }
        
        let datas = items[id: yearMonth]?.datas
        guard datas == nil, (datas?.isEmpty ?? true) else { return }
        
        let newItem = AllScheduleModel(yearMonth: yearMonth, datas: datas)

        guard items.index(id: currentYearMonth) != nil else {
            return
        }
        
        if yearMonth < currentYearMonth {
            items.updateOrInsert(newItem, at: 0)
        } else if yearMonth > currentYearMonth {
            items.updateOrAppend(newItem)
        }

        print("ensureMonthExists: \(yearMonth) added. Total items: \(items.count)")
    }
    
    private func loadDataFromServer(yearMonth: Date) async throws {
        print("### Load From Server yearMonth: \(yearMonth) ###")

        let components = calendar.dateComponents([.year, .month], from: yearMonth)

        guard let year = components.year, let month = components.month else { return }

        let data = try await useCase.loadSchedules(model: .init(year: year, month: month))

        guard data?.isSuccess ?? false else { return }

        let yearMonthString = yearMonth.toString(.yearMonth)
        guard items[id: yearMonthString] != nil else { return }

        if let data = data?.data {
            let datas = data.dates.map({ $0.toEntity() })
            items[id: yearMonthString]?.datas = datas
            print("### Loaded \(yearMonthString): \(datas.count) days")
        } else {
            // 데이터가 없어도 빈 배열로 설정 (중복 로드 방지)
            items[id: yearMonthString]?.datas = []
            print("### Loaded \(yearMonthString): empty")
        }
    }
}
// MARK: - User Action
extension AllScheduleViewModel {
    // 세션 상세 클릭
    func clickSessionDetail(id: String) {
        navigation.push(path: .sessionDetail(id: id))
    }
}
