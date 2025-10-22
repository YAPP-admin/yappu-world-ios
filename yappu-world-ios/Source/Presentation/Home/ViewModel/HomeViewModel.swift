//
//  HomeViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import Foundation
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
    
    var upcomingSession: SessionDetailsEntity?
    
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
        // 시작일이 지났는지 확인
        if isSessionAfterStartDate, let session = upcomingSession {
            // 날짜 포함 형식: "12.06 (금) 오후 8시 - 12.07 (토) 오후 3시"
            let startDateTime = "\(session.startDate) \(session.startTime)"
                .toDate(.sessionDateTime)
            let endDateTime = "\(session.endDate) \(session.endTime)"
                .toDate(.sessionDateTime)

            guard let startDateTime, let endDateTime else { return nil }

            let startDateString = startDateTime.toString(.dateWithWeekday)
            let startTimeString = startDateTime.toString(.simpleTime)
            let endDateString = endDateTime.toString(.dateWithWeekday)
            let endTimeString = endDateTime.toString(.simpleTime)

            return "\(startDateString) \(startTimeString) - \(endDateString) \(endTimeString)"
        }

        // 당일: 시간만 표시 "오후 6시 - 오후 8시"
        guard let todaySession = todaySession,
              let startTime = todaySession.time,
              let endTime = todaySession.endTime
        else { return nil }

        guard let start = startTime.toDate(.sessionTime),
              let end = endTime.toDate(.sessionTime)
        else { return nil }

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

    var isSessionAfterStartDate: Bool {
        guard let session = upcomingSession else { return false }
        let today = Date().toString(.sessionDate)
        return isDateAfter(date: today, than: session.startDate)
    }

    var attendanceHistories: [ScheduleEntity] = [.dummy(), .dummy(), .dummy()]

    var upcomingState: UpcomingSessionAttendanceState {
        guard let session = upcomingSession else { return .NOSESSION }

        // 오늘 세션인지 확인
        let isToday = (session.relativeDays == 0)
        || (session.startDate == Date().toString(.sessionDate))
        if isToday {
            // 오늘 세션의 경우 todaySession의 attendanceStatus 확인
            if let todaySession = todaySession,
               let status = todaySession.attendanceStatus,
               let sessionStatus = SessionStatus(rawValue: status) {
                return sessionStatus.attendanceState
            }

            // 출석 상태가 없으면 시간 기반으로 판단
            if let attendanceAvailability = checkAttendanceAvailability(for: session) {
                return attendanceAvailability
            }

            // 진행 상태에 따라 처리 (fallback)
            switch session.progressPhase {
            case .today, .ongoing:
                return .AVAILABLE
            case .done:
                return .INACTIVE_DAY
            default:
                return .INACTIVE_DAY
            }
        }

        // 미래 세션: 날짜 정보 추출
        guard session.startDate.isEmpty.not()
        else { return .INACTIVE_YET("") }
        return extractDateFromSession(session.startDate)
    }

    private func isDateAfter(date: String, than compareDate: String) -> Bool {
        guard let currentDate = date.toDate(.sessionDate),
              let compareToDate = compareDate.toDate(.sessionDate) else {
            return false
        }

        return currentDate > compareToDate
    }

    private func checkAttendanceAvailability(
        for session: SessionDetailsEntity
    ) -> UpcomingSessionAttendanceState? {
        // 세션 시작 시간 파싱
        let sessionStartTime = "\(session.startDate) \( session.startTime)"
            .toDate(.sessionDateTime)
        let sessionEndTime = "\(session.endDate) \( session.endTime)"
            .toDate(.sessionDateTime)
        guard let sessionStartTime, let sessionEndTime else {
            return nil
        }

        let attendanceStartTime = sessionStartTime
            .addingTimeInterval(-20 * 60) // 20분 전

        if .now < attendanceStartTime {
            // 출석 가능 시간 전
            return .INACTIVE_DAY
        } else if .now > sessionEndTime {
            // 세션 종료 후
            return .ABSENT
        } else {
            // 출석 가능 시간
            return .AVAILABLE
        }
    }

    private func extractDateFromSession(
        _ dateString: String
    ) -> UpcomingSessionAttendanceState {
        let components = dateString.split(separator: "-")
        guard components.count >= 3 else { return .INACTIVE_YET("") }

        let month = components[1]
        let day = components[2]
        return .INACTIVE_YET("\(month)월 \(day)일")
    }

    var activitySessions = IdentifiedArrayOf<ScheduleEntity>()
    
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
            resetState()
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
}
// MARK: - Private Async Methods
private extension HomeViewModel {
    func loadSessions() async {
        do {
            let calendar = Calendar.current
            guard let start = calendar.date(from: calendar.dateComponents([.year, .month], from: .now)),
                  let range = calendar.range(of: .day, in: .month, for: start),
                  let end = calendar.date(byAdding: .day, value: range.count + 6, to: start)
            else { return }
            let generation = await userStorage.loadUser()?.activityUnits.first?.generation
            
            let sessionsResponse = try await sessionUseCase.loadSessionsByHome(
                generation,
                start.toString(.sessionDate),
                end.toString(.sessionDate)
            )
            guard let sessionsResponse else { return }
            
            let schedules = sessionsResponse.data.sessions.map { $0.toEntity() }

            self.activitySessions = .init(uniqueElements: schedules)

            if let upcomingSessionId = sessionsResponse.data.upcomingSessionId {
                let detail = try await sessionUseCase.detail(upcomingSessionId)
                self.upcomingSession = detail
            } else if let todayScheduleId = schedules.first(where: { schedule in
                let isToday = (schedule.relativeDays == 0)
                || (schedule.date == Date().toString(.sessionDate))
                return isToday
            })?.id {
                let detail = try await sessionUseCase.detail(todayScheduleId)
                self.upcomingSession = detail
            } else {
                self.upcomingSession = nil
            }
        } catch(let error as YPError) {
            errorHandling(error)
        } catch {
            print(error)
        }
    }
    
    private func fetchAttendance() async {
        guard let upcomingSession else { return }

        do {
            let _ = try await useCase.fetchAttendance(
                model: .init(sessionId: upcomingSession.id, attendanceCode: otpText)
            )
            
            await loadSessions()
            
            reset() // 닫기
        } catch(let error as YPError) {
            switch error.errorCode {
            case "ATD_1001":
                otpState = .error("출석코드가 일치하지 않습니다. 다시 확인해주세요")
            case "USR_0006": // 활성화 된 기수가 없어서 임박한 세션이 존재하지 않습니다
                self.upcomingSession = nil
            default:
                otpState = .error(error.message)
            }
            isInvalid.toggle() // 흔들리는 효과
        } catch {
            print(error)
        }
    }
    
    func loadAttendanceHistory() async {
        do {
            let datas = try await attendanceUseCase.loadHistory()
            
            if datas?.isSuccess ?? false {
                guard let data = datas?.data else { return }
                if data.histories.count >= 5 {
                    self.attendanceHistories = Array(data.histories.map { $0.toEntity() }.prefix(5))
                } else {
                    self.attendanceHistories = data.histories.map { $0.toEntity() }
                }
            }
        } catch(let error as YPError) {
            errorHandling(error)
        } catch {
            print(error)
        }
    }
    
    func errorHandling(_ error: YPError) {
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
