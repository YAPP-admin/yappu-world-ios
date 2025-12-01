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
    
    var upcomingSession: UpcomingSession?

    var todayProgressPhase: ScheduleEntity.ProgressPhase? {
        guard let session = upcomingSession else { return nil }
        return ScheduleEntity.ProgressPhase(rawValue: session.progressPhase)
    }

    var todaySessionTime: String? {
        guard let session = upcomingSession,
              let startTime = session.startTime,
              let endTime = session.endTime
        else { return nil }

        let startDateTime = "\(session.startDate) \(startTime)".toDate(.sessionDateTime)
        let endDateTime = "\(session.endDate) \(endTime)".toDate(.sessionDateTime)

        guard let startDateTime, let endDateTime else { return nil }

        // ONGOING 상태(시작일이 지난 경우): 날짜 포함 형식
        // "12.06 (금) 오후 8시 - 12.07 (토) 오후 3시"
        if session.progressPhase == "ONGOING" {
            let startDateString = startDateTime.toString(.dateWithWeekday)
            let startTimeString = startDateTime.toString(.activitySessionTimeExtend)
            let endDateString = endDateTime.toString(.dateWithWeekday)
            let endTimeString = endDateTime.toString(.activitySessionTimeExtend)

            return "\(startDateString) \(startTimeString) - \(endDateString) \(endTimeString)"
        }

        // TODAY/PENDING: 시간만 표시 "오후 6시 - 오후 8시"
        let startString = startDateTime.toString(.activitySessionTimeExtend)
        let endString = endDateTime.toString(.activitySessionTimeExtend)

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

        // 출석 상태가 있으면 해당 상태 반환
        if let status = session.status,
           let sessionStatus = SessionStatus(rawValue: status) {
            return sessionStatus.attendanceState
        }

        // progressPhase에 따라 처리
        switch session.progressPhase {
        case "TODAY", "ONGOING":
            // canCheckIn이 true면 출석 가능, false면 출석 불가
            return session.canCheckIn ? .AVAILABLE : .INACTIVE_DAY
        case "DONE":
            // 세션 종료 후 출석 안한 경우 결석
            return .ABSENT
        case "PENDING":
            // 미래 세션: 날짜 정보 추출
            guard session.startDate.isEmpty.not() else { return .INACTIVE_YET("") }
            return extractDateFromSession(session.startDate)
        default:
            return .INACTIVE_YET("")
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
        await loadUpcomingSession()
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
        navigation.push(path: .sessionDetail(id: session.sessionId, entity: nil))
    }

    func attendanceScoreButtonAction() {
        navigation.push(path: .attendances)
    }

    func allSessionButtonAction() {
        tabRouter.switch(.schedule)
        delegate?.allSessionButtonAction()
    }
    
    func clickBaseRule() {
        guard let url = OperationManager.기본_규칙_URL.secureURL else {
            return
        }
        navigation.push(path: .safari(url: url))
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
        } catch(let error as YPError) {
            errorHandling(error)
        } catch {
            print(error)
        }
    }

    func loadUpcomingSession() async {
        do {
            let response = try await useCase.loadUpcomingSession()
            self.upcomingSession = response.data
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
                model: .init(sessionId: upcomingSession.sessionId, attendanceCode: otpText)
            )

            await loadUpcomingSession()

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
