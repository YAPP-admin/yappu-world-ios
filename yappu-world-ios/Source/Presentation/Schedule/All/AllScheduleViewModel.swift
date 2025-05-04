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
    
    let lock = NSLock()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter
    
    var scrollTimer: Task<Void, Error>?
    var loadTimer: Task<Void, Error>?
    private var loadingMonths = Set<String>()
    private(set) var lastVisibleIndex: Int = 6
    private(set) var currentYearMonth: String = ""
    private var isScrolling: Bool = false
    var isPreviousChanged: Bool = false
    
    private var isInit: Bool = false
    
    var scrollPosition: Int? {
        didSet {
            print("didSet ScrollPosition", scrollPosition)
        }
    }
    //var currentIndex = 6
    var isLoading: Bool = false
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        // 현재 날짜로 currentYearMonth 초기화
        currentYearMonth = dateFormatter.string(from: Date())
        
        // 초기 1년치 데이터 로드 (이전 6개월 + 현재 + 이후 6개월)
        initCalendar()
    }
    
    private func initCalendar() {
        
        // 초기 1년치 데이터 로드 (이전 6개월 + 현재 + 이후 6개월)
        var tempItems: [AllScheduleModel] = []
        let currentDate = Date()
        
        for month in -6...6 {
            if let date = calendar.date(byAdding: .month, value: month, to: currentDate) {
                let yearMonth = dateFormatter.string(from: date)
                tempItems.append(.init(yearMonth: yearMonth, datas: nil, isEmpty: false))
            }
        }
        
        items = tempItems
        scrollPosition = 6
    }
    
    func onTask() async {
        
        guard isInit.not() else { return }
        
        do {
            try await loadDataFromServer(yearMonth: Date())
            isInit = true
        } catch {
            print("dsa")
        }
    }
    
    func nextButtonAction() {
        guard let preIndex = scrollPosition else { return }
        scrollPosition = preIndex + 1
    }
    
    func previousButtonAction() {
        guard let preIndex = scrollPosition else { return }
        scrollPosition = preIndex - 1
    }
    
    func onChangeTask() async throws {
        
        scrollTimer?.cancel()
        scrollTimer = Task {
            do {
                
                guard let id = scrollPosition else { return }
                
                if items[safe: id]?.datas == nil {
                    await MainActor.run {
                        isLoading = true
                    }
                }
                
                try await Task.sleep(nanoseconds: 200_000_000)
                
                print("-- onChangeTask is Called -- id: \(id)")
                print("isPreviousChanged : \(isPreviousChanged)")
                
                switch isPreviousChanged {
                case true :
                    break
                case false:
                    if id < 2 {
                        try await previousAction(id: id)
                        try await addCurrentIndex()
                    } else if id > items.count - 2 {
                        await nextAction(id: id)
                    }
                }
                
                guard let stringDate = items[safe: id]?.yearMonth else { return }
                guard let date = dateFormatter.date(from: stringDate) else { return }
                 
                await MainActor.run {
                    if isPreviousChanged.not() {
                        currentYearMonth = dateFormatter.string(from: date)
                    }
                    isLoading = false
                }
                
                if isPreviousChanged {
                    try await Task.sleep(nanoseconds: 100_000_000)
                    isPreviousChanged = false
                }
                
                if items[safe: id]?.datas == nil {
                    loadTimer?.cancel()
                    try await Task.sleep(nanoseconds: 100_000_000)
                    loadTimer = Task {
                        try await loadDataFromServer(yearMonth: date)
                    }
                }
                
                await MainActor.run {
                    isLoading = false
                }
            } catch { }
        }
        
    }
    
    private func previousAction(id: Int?) async throws {
        print("previousAction is Called")
        
        guard let firstDate = items.first?.yearMonth else { return }
        guard let targetDate = dateFormatter.date(from: firstDate) else { return }
        
        await MainActor.run {
            var tempItems: [AllScheduleModel] = []
            
            for month in (1...6).reversed() {
                if let date = calendar.date(byAdding: .month, value: -month, to: targetDate) {
                    let yearMonth = dateFormatter.string(from: date)
                    tempItems.append(.init(yearMonth: yearMonth, datas: nil, isEmpty: false))
                }
            }
            
            items = tempItems + items

            guard let dateString = items[safe: 7]?.yearMonth else { return }
            currentYearMonth = dateString
            
            print("items CurrentData count \(items.count)")
            
        }
    }
    
    private func addCurrentIndex() async throws {
        try await Task.sleep(nanoseconds: 100_000_000)
        
        await MainActor.run {
            isPreviousChanged = true
            let mid = 7
            scrollPosition = mid
        }
    }
    
    private func nextAction(id: Int?) async {
        
        print("nextAction is Called")
        
        guard let lastDate = items.last?.yearMonth else { return }
        guard let targetDate = dateFormatter.date(from: lastDate) else { return }
        
        await MainActor.run {
            var tempItems: [AllScheduleModel] = []
            
            for month in 1...6 {
                if let date = calendar.date(byAdding: .month, value: month, to: targetDate) {
                    let yearMonth = dateFormatter.string(from: date)
                    tempItems.append(.init(yearMonth: yearMonth, datas: nil, isEmpty: false))
                }
            }
            
            items.append(contentsOf: tempItems)
            
            print("items CurrentData count \(items.count)")
        }
    }
    
    private func loadDataFromServer(yearMonth: Date) async throws {
        
        print("### Load From Server yearMonth: \(yearMonth) ###")
        
        let components = calendar.dateComponents([.year, .month], from: yearMonth)
        
        guard let year = components.year, let month = components.month else { return }
        
        let data = try await useCase.loadSchedules(model: .init(year: year, month: month))
        
        guard data?.isSuccess ?? false else { return }
        
        if let data = data?.data, data.dates.isEmpty.not() {
            let yearMonthString = dateFormatter.string(from: yearMonth)
            guard let index = items.firstIndex(where: { $0.yearMonth == yearMonthString }) else { return }
            
            await MainActor.run {
                
                let datas = data.dates.map({ $0.toEntity() })
                items[index].datas = datas
                items[index].isEmpty = datas.filter({ $0.schedules.isEmpty.not() }).count == 0
            }
        }
    }
    
    // yearMonth 문자열을 Date 객체로 변환
    private func dateFromYearMonth(_ yearMonth: String) -> Date? {
        return dateFormatter.date(from: yearMonth)
    }
}


// MARK: - Scroll Func
extension AllScheduleViewModel {
    
}

//MARK: - Non API Function
extension AllScheduleViewModel {
    
   func loadSchedules(selectedYearMonth: String) async throws {
       
   }
}
