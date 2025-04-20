//
//  AllScheduleViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/19/25.
//

import Foundation
import Dependencies
import DependenciesMacros

@Observable
class AllScheduleViewModel {
    
    @ObservationIgnored
    @Dependency(ScheduleUseCase.self)
    private var useCase
    
    var items: [AllScheduleModel] = []
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter
    
    private let serialQueue = DispatchQueue(label: "com.yappu-world-ios.scheduleViewModel.serialQueue")
    
    private var loadingMonths = Set<String>()
    private var scrollingTask: Task<Void, Never>?
    private var lastVisibleIndex: Int = 0
    private var isScrolling: Bool = false
    
    var currentIndex = 6
    var isLoading: Bool = false
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        // 초기 1년치 데이터 로드 (이전 6개월 + 현재 + 이후 6개월)
        Task {
            await loadInitialSchedule()
        }
    }
    
    func onTask() async {
        if let initialYearMonth = items[safe: currentIndex]?.yearMonth {
            try? await loadSchedules(selectedYearMonth: initialYearMonth)
        }
    }
    
    func updateScrollState(isScrolling: Bool) {
        self.isScrolling = isScrolling
        
        if !isScrolling {
            loadDataForCurrentVisibleIndex()
        } else {
            scrollingTask?.cancel()
        }
    }
    
    func updateVisibleIndex(_ index: Int) {
        lastVisibleIndex = index
        
        if !isScrolling {
            loadDataForCurrentVisibleIndex()
        }
    }
    
    private func loadDataForCurrentVisibleIndex() {
        scrollingTask?.cancel()
        
        scrollingTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            if Task.isCancelled { return }
            
            guard lastVisibleIndex >= 0, lastVisibleIndex < items.count else { return }
            
            let currentYearMonth = items[lastVisibleIndex].yearMonth
            
            do {
                try await loadSchedules(selectedYearMonth: currentYearMonth, priority: .high)
                
                if Task.isCancelled { return }
                
                // 인접 페이지 미리 로드 (우선순위 낮게)
                let adjacentIndices = [lastVisibleIndex - 1, lastVisibleIndex + 1]
                    .filter { $0 >= 0 && $0 < items.count }
                
                for adjacentIndex in adjacentIndices {
                    if Task.isCancelled { return }
                    let yearMonth = items[adjacentIndex].yearMonth
                    try? await loadSchedules(selectedYearMonth: yearMonth, priority: .low)
                }
            } catch {
                print("Failed to load data for index \(lastVisibleIndex): \(error)")
            }
        }
    }
     
    func loadSchedules(selectedYearMonth: String, priority: TaskPriority = .medium) async throws {
        
        // 불러오는 달 인지 체크
        let isAlreadyLoading = await serialQueue.async { [weak self] () -> Bool in
            guard let self else { return true }
            if self.loadingMonths.contains(selectedYearMonth) {
                return true
            }
            
            self.loadingMonths.insert(selectedYearMonth)
            return false
        }
        
        
        // 이미 불러오는 중이라면 return
        if isAlreadyLoading {
            return
        }
        
        // 이미 불러온 데이터가 있을 경우 체크
        let dataAlreadyLoaded = await serialQueue.async { [weak self] () -> Bool in
            guard let self else { return false }
            if let index = self.items.firstIndex(where: { $0.yearMonth == selectedYearMonth }),
               !self.items[index].datas.isEmpty {
                return true
            }
            return false
        }
        
        
        // 이미 데이터가 있고 우선순위가 높지 않으면 스킵
        if dataAlreadyLoaded && priority != .high {
            await serialQueue.async { [weak self] in
                guard let self else { return }
                self.loadingMonths.remove(selectedYearMonth)
            }
            return
        }
        
        defer {
            Task {
                await serialQueue.async { [weak self] in
                    guard let self else { return }
                    self.loadingMonths.remove(selectedYearMonth)
                }
            }
        }
        
        
        do {
            // 현재 아이템 상태 스냅샷 생성
            let selectIndex = await serialQueue.async { [weak self] () -> Int? in
                guard let self else { return nil }
                guard let index = self.items.firstIndex(where: { $0.yearMonth == selectedYearMonth }) else { return nil }
                return index
            }
            
            
            // 값이 nil일 경우 로드 종료
            guard let selectIndex = selectIndex else {
                await serialQueue.async { [weak self] in
                    guard let self else { return }
                    self.loadingMonths.remove(selectedYearMonth)
                }
                
                return
            }
            
            let compoents = selectedYearMonth.split(separator: "-")
            guard compoents.count == 2,
                  let year = Int(compoents[0]),
                  let month = Int(compoents[1]) else {
                throw NSError(domain: "연/월 생성에 실패했습니다.", code: 1)
            }
            
            if priority == .high {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.isLoading = true
                }
            }
            
            let response = try await useCase.loadSchedules(model: .init(year: year, month: month))
            let entity = response?.data.toEntity()
            
            if Task.isCancelled { return }
            
            // 로드 중간에 인덱스가 바뀔 수가 있으니 한번 더 확인함
            let isStillValid = await serialQueue.async { [weak self] () -> Bool in
                guard let self else { return false }
                guard selectIndex < self.items.count else { return false }
                let currentItem = self.items[selectIndex]
                return currentItem.yearMonth == selectedYearMonth
            }
            
            if isStillValid, let entity = entity {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    if selectIndex < self.items.count && self.items[selectIndex].yearMonth == selectedYearMonth {
                        self.items[selectIndex].datas = entity.dates
                        
                        // 로딩 상태 해제
                        if priority == .high {
                            self.isLoading = false
                        }
                    }
                }
            } else {
                if priority == .high {
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                        self.isLoading = false
                    }
                }
            }
        } catch {
            print("load Schedules Error: \(error)")
            
            if priority == .high {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.isLoading = false
                }
            }
            
            throw error
        }
    }
    
    // yearMonth 문자열을 Date 객체로 변환
    private func dateFromYearMonth(_ yearMonth: String) -> Date? {
        return dateFormatter.date(from: yearMonth)
    }
}


//MARK: - Non API Function
extension AllScheduleViewModel {
    
    // TabView 체크
    func checkForAdditionDataLoad(_ index: Int) {
        
        guard index >= 0, index < items.count else { return }
        
        let currentYearMonth: String = items[index].yearMonth
        
        Task {
            do {
                try await loadSchedules(selectedYearMonth: currentYearMonth)
            } catch {
                // 에러 처리 (UI에 표시하거나 로깅)
                print("Failed to load schedules: \(error)")
            }
        }
        
        if index <= 2 {
            Task {
                await loadPreviousMonths()
                
                await MainActor.run {
                    currentIndex += 6
                }
            }
        }
        
        if index >= items.count - 3 {
            Task {
                await loadNextMonths()
            }
        }
    }
    
    private func loadInitialSchedule() async {
        let scheduleItems = await withTaskGroup(of: [AllScheduleModel].self) { group in
            group.addTask {
                return await self.generateInitialSchedule()
            }
            
            // 결과 수집 및 반환
            var result: [AllScheduleModel] = []
            for await items in group {
                result = items
            }
            return result
        }
        
        // UI 업데이트는 MainActor에서 수행
        await MainActor.run {
            self.items = scheduleItems
        }
    }
    
    
    
    // 초기 데이터 (이전 6개월 + 현재 + 이후 6개월)
    private func generateInitialSchedule() async -> [AllScheduleModel] {
        var scheduleitems: [AllScheduleModel] = []
        
        let currentDate = Date()
        let calendar = self.calendar
        
        guard let sixMonthsAgo = calendar.date(byAdding: .month, value: -6, to: currentDate) else {
            print("sixMonthsAgo error")
            return []
        }
        
        for i in 0..<13 {
            guard let targetDate = calendar.date(byAdding: .month, value: i, to: sixMonthsAgo) else {
                print("targetDate error")
                return []
            }
            let yearMonthString = dateFormatter.string(from: targetDate)
            let scheduleModel = AllScheduleModel(yearMonth: yearMonthString, datas: [])
            
            scheduleitems.append(scheduleModel)
        }
        
        return scheduleitems
    }
    
    // 왼쪽(이전) 6개월 추가
    func loadPreviousMonths() async {
        
        let newItems = await serialQueue.async { [weak self] () -> [AllScheduleModel] in
            guard let self = self, let firstItem = self.items.first else { return [] }
            
            var newScheduleItems: [AllScheduleModel] = []
            
            if let firstDate = dateFromYearMonth(firstItem.yearMonth) {
                for i in 1...6 {
                    if let newDate = calendar.date(byAdding: .month, value: -i, to: firstDate) {
                        let yearMonthString = dateFormatter.string(from: newDate)
                        let scheduleModel = AllScheduleModel(yearMonth: yearMonthString, datas: [])
                        newScheduleItems.insert(scheduleModel, at: 0)
                    }
                }
            }
            return newScheduleItems
        }
        
        await MainActor.run { [weak self] in
            guard let self = self else { return }
            self.items.insert(contentsOf: newItems, at: 0)
        }
    }
    
    // 오른쪽(이후) 6개월 추가
    func loadNextMonths() async {
        
        let newItems = await serialQueue.async { [weak self] () -> [AllScheduleModel] in
            guard let self = self, let lastItem = self.items.last else { return [] }
            var newScheduleItems: [AllScheduleModel] = []
            
            if let lastDate = dateFromYearMonth(lastItem.yearMonth) {
                for i in 1...6 {
                    if let newDate = calendar.date(byAdding: .month, value: i, to: lastDate) {
                        let yearMonthString = dateFormatter.string(from: newDate)
                        let scheduleModel = AllScheduleModel(yearMonth: yearMonthString, datas: [])
                        newScheduleItems.append(scheduleModel)
                    }
                }
            }
            return newScheduleItems
        }
        
        await MainActor.run { [weak self] in
            guard let self = self else { return }
            self.items.append(contentsOf: newItems)
        }
        
    }
}
