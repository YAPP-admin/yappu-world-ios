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
import IdentifiedCollections

@Observable
class HomeViewModel {
    @ObservationIgnored
    @Dependency(Navigation<TabViewGlobalPath>.self)
    private var navigation
    
    @ObservationIgnored
    @Dependency(Router<TabItem>.self)
    private var tabRouter
    
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
    @Dependency(SessionUseCase.self)
    private var sessionUseCase
    
    @ObservationIgnored
    @Dependency(\.userStorage)
    private var userStorage
    
    var upcomingSession: UpcomingSession? = .todaySession()
    
    var todayProgressPhase: ScheduleEntity.ProgressPhase? {
        return todaySession?.scheduleProgressPhase
    }

    var todaySession: ScheduleEntity? {
        let today = Date().toString(.sessionDate)
        return activitySessions.first { session in
            session.date == today
        }
    }

    var todaySessionTime: String? {
        guard let todaySession = todaySession,
              let startTime = todaySession.time,
              let endTime = todaySession.endTime else { return nil }

        guard let start = startTime.toDate(.sessionTime),
              let end = endTime.toDate(.sessionTime) else { return nil }

        let startString = start.toString(.simpleTime)
        let endString = end.toString(.simpleTime)

        return "\(startString) - \(endString)"
    }

    var hasAttendanceProcessed: Bool {
        return upcomingState == .ATTENDED
        || upcomingState == .LATE
        || upcomingState == .EARLY_LEAVE
        || upcomingState == .EXCUSED
    }

    var cannotSubmitAttendance: Bool {
        return hasAttendanceProcessed || upcomingState == .ABSENT
    }

    var attendanceHistories: [ScheduleEntity] = [.dummy(), .dummy(), .dummy()]

    var upcomingState: UpcomingSessionAttendanceState {
        guard let session = upcomingSession else { return .NOSESSION }

        // 출석 상태가 있는 경우 해당 상태 반환
        if let status = session.status,
           let sessionStatus = SessionStatus(rawValue: status) {
            return sessionStatus.attendanceState
        }

        // 출석 가능 시간
        if session.canCheckIn {
            return .AVAILABLE
        }

        // 오늘 세션이지만 아직 상태가 없는 경우
        if session.relativeDays == 0 {
            return .INACTIVE_DAY
        }

        // 미래 세션: 날짜 정보 추출
        return extractDateFromSession(session.startDate)
    }

    private func extractDateFromSession(_ dateString: String) -> UpcomingSessionAttendanceState {
        let components = dateString.split(separator: "-")
        guard components.count >= 3 else { return .INACTIVE_YET("") }

        let month = components[1]
        let day = components[2]
        return .INACTIVE_YET("\(month)월 \(day)일")
    }

    var activitySessions = IdentifiedArrayOf<ScheduleEntity>(uniqueElements: ScheduleEntity.mockList)
    
    var isSheetOpen: Bool = false
    var otpText: String = ""
    var otpState: InputState = .typing
    var isInvalid: Bool = false
    var otpCount: Int = 4
    
    func resetState() {
        upcomingSession = nil
    }
    
    func scrollViewRefreshable() async {
        do {
            await MainActor.run {
                resetState()
            }
            
            let _ = try await Task {
                try await Task.sleep(for: .seconds(1))
                await onTask()
                return true
            }.value
        } catch {
            print("error", error.localizedDescription)
        }
    }
    
    func onTask() async {
        await loadAttendanceHistory()
        await loadUpcomingSession()
        await loadSessions()
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
        if cannotSubmitAttendance { return }
        isSheetOpen.toggle()
    }
    
    func verifyOTP() async {
        await fetchAttendance()
    }
    
    func clickBackButton() {
        navigation.pop()
    }
    
    func clickAllSessionButton() {
        tabRouter.switch(.schedule)
    }
}
// MARK: - Private Async Methods
private extension HomeViewModel {
    
    private func loadUpcomingSession() async {
        do {
            let upcomingSessionsResponse = try await useCase.loadUpcomingSession()

            await MainActor.run {
                self.upcomingSession = upcomingSessionsResponse.data
            }
        } catch(let error as YPError) {
            errorHandling(error)
        } catch {
            print(error)
        }
    }

    private func combine(
        date dateString: String,
        time timeString: String?,
        fallback: DateComponents = DateComponents(hour: 0, minute: 0, second: 0)
    ) -> Date? {
        guard let date = dateString.toDate(.sessionDate) else { return nil }
        let calendar = Calendar.current
        if let timeString, let time = timeString.toDate(.sessionTime) {
            let components = calendar.dateComponents([.hour, .minute, .second], from: time)
            return calendar.date(
                bySettingHour: components.hour ?? fallback.hour ?? 0,
                minute: components.minute ?? fallback.minute ?? 0,
                second: components.second ?? fallback.second ?? 0,
                of: date
            )
        }
        return calendar.date(
            bySettingHour: fallback.hour ?? 0,
            minute: fallback.minute ?? 0,
            second: fallback.second ?? 0,
            of: date
        )
    }
    
    enum SessionStatus: String {
        case attended    = "출석"
        case late        = "지각"
        case absent      = "결석"
        case earlyLeave  = "조퇴"
        case excused     = "공결"

        var attendanceState: UpcomingSessionAttendanceState {
            switch self {
            case .attended: return .ATTENDED
            case .late: return .LATE
            case .absent: return .ABSENT
            case .earlyLeave: return .EARLY_LEAVE
            case .excused: return .EXCUSED
            }
        }
    }


    private func loadSessions() async {
        do {
            let calendar = Calendar.current
            guard
                let start = calendar.date(from: calendar.dateComponents([.year, .month], from: .now)),
                let range = calendar.range(of: .day, in: .month, for: start),
                let end = calendar.date(byAdding: .day, value: range.count + 6, to: start)
            else { return }
            let generation = await userStorage.user?.activityUnits.first?.generation
            
            let sessionsResponse = try await sessionUseCase.loadSessionsByHome(
                generation,
                start.toString(.sessionDate),
                end.toString(.sessionDate)
            )
            guard let sessionsResponse else { return }
            
//            self.activitySessions = .init(uniqueElements: sessionsResponse.data.sessions.map { $0.toEntity() })
        } catch(let error as YPError) {
            errorHandling(error)
        } catch {
            print(error)
        }
    }
    
    private func fetchAttendance() async {
        guard let upcomingSession = upcomingSession else { return }
        
        do {
            let _ = try await useCase.fetchAttendance(
                model: .init(sessionId: upcomingSession.sessionId, attendanceCode: otpText)
            )
            
            let upcomingSessionsResponse = try await useCase.loadUpcomingSession()

            await MainActor.run {
                self.upcomingSession = upcomingSessionsResponse.data
                reset() // 닫기
            }
        } catch {            
            guard let ypError = error as? YPError else { return }
            switch ypError.errorCode {
            case "ATD_1001":
                otpState = .error("출석코드가 일치하지 않습니다. 다시 확인해주세요")
            case "USR_0006": // 활성화 된 기수가 없어서 임박한 세션이 존재하지 않습니다
                self.upcomingSession = nil
            default:
                otpState = .error(ypError.message)
            }
            isInvalid.toggle() // 흔들리는 효과
        }
    }
    
    private func loadAttendanceHistory() async {
        do {
            let datas = try await attendanceUseCase.loadHistory()
            
            if datas?.isSuccess ?? false {
                guard let data = datas?.data else { return }
                await MainActor.run {
                    if data.histories.count >= 5 {
                        self.attendanceHistories = Array(data.histories.map { $0.toEntity() }.prefix(5))
                    } else {
                        self.attendanceHistories = data.histories.map { $0.toEntity() }
                    }
                }
            }
        } catch(let error as YPError) {
            errorHandling(error)
        } catch {
            print(error)
        }
    }
    
    private func errorHandling(_ error: YPError) {
        switch error.errorCode {
        case "SCH_1005": // 예정된 세션이 존재하지 않습니다
            self.upcomingSession = nil
        case "USR_0006": // 해당 세대의 활동 정보를 가진 유저를 찾을 수 없습니다.
            self.upcomingSession = nil
        default:
            break
        }
    }
}
