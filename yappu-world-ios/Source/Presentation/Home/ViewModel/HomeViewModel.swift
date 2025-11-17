//
//  HomeViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/2/25.
//

import Foundation
import SwiftUI
import Dependencies

protocol HomeViewModelDelegate: AnyObject {
    func allSessionButtonAction()
}

extension HomeViewModelDelegate {
    func allSessionButtonAction() { }
}

@Observable
class HomeViewModel {
    @ObservationIgnored
    weak var delegate: HomeViewModelDelegate?

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
    
    var upcomingSession: SessionDetailEntity?
    
    var todayProgressPhase: ScheduleEntity.ProgressPhase? {
        return todaySession?.scheduleProgressPhase
    }

    var todaySession: ScheduleEntity? {
        let today = Date().toString(.sessionDate)

        // 오늘 날짜로 시작하는 세션 또는 진행중인 세션(시작일은 지났고 종료일은 안 지남)
        return activitySessions.first { session in
            // 오늘 시작하는 세션
            if session.date == today {
                return true
            }

            // 진행중인 세션: 시작일 <= 오늘 <= 종료일
            if session.scheduleProgressPhase == .ongoing {
                return true
            }

            return false
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
            let startTimeString = startDateTime.toString(.activitySessionTime)
            let endDateString = endDateTime.toString(.dateWithWeekday)
            let endTimeString = endDateTime.toString(.activitySessionTime)

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

        let startString = start.toString(.activitySessionTime)
        let endString = end.toString(.activitySessionTime)

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

        // 시작일이 오늘이면 false (날짜 포함 형식 사용 안함)
        if session.startDate == today {
            return false
        }

        // 오늘이 시작일보다 나중이면 true (날짜 포함 형식 사용)
        return isDateAfter(date: today, than: session.startDate)
    }

    var attendanceHistories: [ScheduleEntity] = [.dummy(), .dummy(), .dummy()]

    var upcomingState: UpcomingSessionAttendanceState {
        guard let session = upcomingSession else { return .NOSESSION }

        // 오늘 세션인지 확인
        let isToday = (session.startDate == Date().toString(.activitySessionDate))
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

        // 진행중인 세션 확인 (시작일은 지났지만 종료일은 안 지난 경우)
        if session.progressPhase == .ongoing {
            // 세션 시작일의 출석 상태 확인
            if let sessionSchedule = activitySessions.first(where: { $0.date == session.startDate }),
               let status = sessionSchedule.attendanceStatus,
               let sessionStatus = SessionStatus(rawValue: status) {
                return sessionStatus.attendanceState
            }

            // 출석 상태가 없으면 AVAILABLE
            return .AVAILABLE
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
        for session: SessionDetailEntity
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
        guard let date = dateString.toDate(.activitySessionDate) else {
            return .INACTIVE_YET("")
        }

        let components = Calendar.current.dateComponents([.month, .day], from: date)
        guard
            let month = components.month,
            let day = components.day
        else {
            return .INACTIVE_YET("")
        }

        return .INACTIVE_YET("\(month)월 \(day)일")
    }

    var activitySessions = [ScheduleEntity]()
    
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

    func sessionNoticeCellButtonAction(id: String) {
        navigation.push(path: .noticeDetail(id: id))
    }

    func sessionDetailButtonAction() {
        guard let session = upcomingSession else { return }
        navigation.push(path: .sessionDetail(id: session.id, entity: session))
    }

    func attendanceScoreButtonAction() {
        navigation.push(path: .attendances)
    }

    func allSessionButtonAction() {
        tabRouter.switch(.schedule)
        delegate?.allSessionButtonAction()
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

            self.activitySessions = schedules

            if let upcomingSessionId = sessionsResponse.data.upcomingSessionId {
                let detail = try await sessionUseCase.loadSessionDetail(upcomingSessionId)
                self.upcomingSession = detail?.data
            } else if let todayScheduleId = schedules.first(where: { schedule in
                let isToday = (schedule.relativeDays == 0)
                || (schedule.date == Date().toString(.sessionDate))
                return isToday
            })?.id {
                let detail = try await sessionUseCase.loadSessionDetail(todayScheduleId)
                self.upcomingSession = detail?.data
            } else if let ongoingScheduleId = schedules.first(where: { schedule in
                schedule.scheduleProgressPhase == .ongoing
            })?.id {
                let detail = try await sessionUseCase.loadSessionDetail(ongoingScheduleId)
                self.upcomingSession = detail?.data
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
