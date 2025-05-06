//
//  HomeViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import Foundation
import Combine
import SwiftUI
import Dependencies

@Observable
class HomeViewModel {
    @ObservationIgnored
    @Dependency(Navigation<TabViewGlobalPath>.self)
    private var navigation
    
    @ObservationIgnored
    @Dependency(HomeUseCase.self)
    private var useCase
    
    @ObservationIgnored
    @Dependency(NoticeUseCase.self)
    private var noticeUseCase
    
    @ObservationIgnored
    @Dependency(AttendanceUseCase.self)
    private var attendanceUseCase
    
    @ObservationIgnored
    @Dependency(\.userStorage)
    private var userStorage
    
    var upcomingSession: UpcomingSession? = nil
    
    var attendanceHistories: [ScheduleEntity] = [.dummy(), .dummy(), .dummy()]
    
    var upcomingState: UpcomingSessionAttendanceState = .NoSession
    
    var isSheetOpen: Bool = false
    var otpText: String = ""
    var otpState: InputState = .typing
    var isInvalid: Bool = false
    var otpCount: Int = 4
    
    func resetState() {
        upcomingSession = nil
        upcomingState = .NoSession
    }
    
    func onTask() async throws {
        do {
            try await loadAttendanceHistory()
            try await loadUpcomingSession()
        } catch(let error as YPError) {
            switch error.errorCode {
            case "SCH_1005": // 예정된 세션이 존재하지 않습니다
                upcomingSession = nil
            case "USR_0006": // 해당 세대의 활동 정보를 가진 유저를 찾을 수 없습니다.
                upcomingSession = nil
            default:
                break
            }
            upcomingState = .NoSession
        }
    }
    
    func reset() {
        otpText = ""
        otpState = .typing
        isSheetOpen.toggle()
    }
    
    func clickNoticeList() {
        navigation.push(path: .noticeList)
    }
    
    func clickNoticeDetail(id: String) {
        navigation.push(path: .noticeDetail(id: id))
    }
    
    func clickAttendanceHistoryMoreButton() {
        navigation.push(path: .attendances)
    }
    
    func clickSetting() {
        navigation.push(path: .setting)
    }
    
    func clickSheetToggle() {
        isSheetOpen.toggle()
    }
    
    func verifyOTP() async {
        await fetchAttendance()
    }
    
    func clickBackButton() {
        navigation.pop()
    }
}
// MARK: - Private Async Methods
private extension HomeViewModel {
    
    private func loadUpcomingSession() async {
        do {
            let upcomingSessionsResponse = try await useCase.loadUpcomingSession()

            await MainActor.run {
                calculateByUpcomingStatus(upcomingSession: upcomingSessionsResponse.data)
            }
        } catch(let error as YPError) {
            upcomingState = .NoSession
        } catch {
            print(error)
        }
    }
    
    private func calculateByUpcomingStatus(upcomingSession: UpcomingSession) {
        self.upcomingSession = upcomingSession
        
        if upcomingSession.status == "출석" {
            upcomingState = .Attended
        } else if upcomingSession.canCheckIn {
            // 출석 가능한 시간인 경우
            upcomingState = .Available
        } else {
            // 출석 가능한 시간은 아니지만, 오늘 날짜인 경우
            if upcomingSession.relativeDays == 0 {
                upcomingState = .Inactive_Dday
            } else {
                let startDate = upcomingSession.startDate.components(separatedBy: "-")
                let month = startDate[1], day = startDate[2]
                upcomingState = .Inactive_Yet("\(month)월 \(day)일")
            }
        }
    }
    
    private func fetchAttendance() async {
        guard let upcomingSession = upcomingSession else { return }
        
        do {
            let _ = try await useCase.fetchAttendance(
                model: .init(sessionId: upcomingSession.sessionId, attendanceCode: otpText) // sessionId 임시
            )
            let upcomingSessionsResponse = try await useCase.loadUpcomingSession()

            await MainActor.run {
                calculateByUpcomingStatus(upcomingSession: upcomingSessionsResponse.data)
                reset() // 닫기
            }
        } catch {
            guard let ypError = error as? YPError else { return }
            switch ypError.errorCode {
            case "ATD_1001":
                otpState = .error("출석코드가 일치하지 않습니다. 다시 확인해주세요")
            case "USR_0006": // 활성화 된 기수가 없어서 임박한 세션이 존재하지 않습니다
                upcomingState = .NoSession
            default:
                otpState = .error(ypError.message)
            }
            isInvalid.toggle() // 흔들리는 효과
        }
    }
    
    private func loadAttendanceHistory() async throws {
        do {
            let datas = try await attendanceUseCase.loadHistory()
            
            if datas?.isSuccess ?? false {
                guard let data = datas?.data else { return }
                await MainActor.run {
                    if data.histories.count >= 5 {
                        self.attendanceHistories = Array(data.histories.map { $0.toEntity() }.prefix(3))
                    } else {
                        self.attendanceHistories = data.histories.map { $0.toEntity() }
                    }
                }
            }
        } catch {
            throw error
        }
    }
}
