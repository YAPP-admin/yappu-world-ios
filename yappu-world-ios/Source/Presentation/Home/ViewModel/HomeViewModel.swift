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
    @Dependency(HomeUseCase.self)
    private var homeUseCase
    
    @ObservationIgnored
    @Dependency(\.userStorage)
    private var userStorage
    
    var upcomingSession: UpcomingSession?
    
    var isSheetOpen: Bool = false
    var otpText: String = ""
    var otpState: InputState = .typing
    var isInvalid: Bool = false
    var otpCount: Int = 4
    var isLoading = true

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

        // 시작일과 종료일이 다른 경우(1박2일 등): 날짜 포함 형식
        // "12.06 (금) 오후 8시 - 12.07 (토) 오후 3시"
        if session.startDate != session.endDate {
            let startDateString = startDateTime.toString(.dateWithWeekday)
            let startTimeString = startDateTime.getCurrentTimeString()
            let endDateString = endDateTime.toString(.dateWithWeekday)
            let endTimeString = endDateTime.getCurrentTimeString()

            return "\(startDateString) \(startTimeString) - \(endDateString) \(endTimeString)"
        }

        // 같은 날: 시간만 표시 "오후 6시 - 오후 8시"
        let startString = startDateTime.getCurrentTimeString()
        let endString = endDateTime.getCurrentTimeString()

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
}

// MARK: - View Methods
extension HomeViewModel {
    @Sendable
    func scrollViewRefreshable() async {
        isLoading = true
        await onTask()
    }
    
    func onTask() async {
        await loadSessionsAndUpcoming()
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
}

// MARK: - Private Methods
private extension HomeViewModel {
    func loadSessionsAndUpcoming() async {
        defer { isLoading = false }
        do {
            // upcoming 세션 조회
            let upcomingSession = try? await homeUseCase.loadUpcomingSession().data
            
            // upcoming 세션이 오늘이거나 다음날 진행중인 경우
            if let upcomingSession, upcomingSession.relativeDays >= 0 {
                self.upcomingSession = upcomingSession
                return
            }
            
            // 당일 종료된 세션 탐색
            if let toodaySession = try await findTodaySession() {
                self.upcomingSession = toodaySession
                return
            }

            // 당일 종료된 세션이 없는 경우
            self.upcomingSession = upcomingSession

        } catch let error as YPError {
            errorHandling(error)
        } catch {
            print(error)
        }
    }
    
    func extractDateFromSession(
        _ dateString: String
    ) -> UpcomingSessionAttendanceState {
        guard let date = dateString.toDate(.sessionDate) else {
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

    /// 임박한 세션 찾기
    /// - upcomingSessionId가 있으면 해당 세션 반환
    /// - 없으면 당일 세션 중 가장 늦게 끝나는 세션 반환
    func findUpcomingSession(from data: SessionsResponse) -> SessionResponse? {
        if let upcomingSessionId = data.upcomingSessionId {
            return data.sessions.first { $0.id == upcomingSessionId }
        }

        return data.sessions
            .filter { $0.relativeDays <= 0 }
            .max { compareEndTime(lhs: $0, rhs: $1) }
    }

    /// 두 세션의 종료 시간 비교
    func compareEndTime(lhs: SessionResponse, rhs: SessionResponse) -> Bool {
        guard let lhsEndTime = lhs.endTime,
              let rhsEndTime = rhs.endTime,
              let lhsEnd = "\(lhs.endDate ?? lhs.date) \(lhsEndTime)".toDate(.sessionDateTime),
              let rhsEnd = "\(rhs.endDate ?? rhs.date) \(rhsEndTime)".toDate(.sessionDateTime)
        else { return false }

        return lhsEnd < rhsEnd
    }

    /// 세션의 공지사항 조회
    func loadNotices(sessionId: String) async throws -> [UpcomingSession.Notice] {
        guard let sessionDetail = try await sessionUseCase.loadSessionDetail(sessionId: sessionId) else {
            return []
        }

        return sessionDetail.data.notices.map {
            UpcomingSession.Notice(id: $0.id, title: $0.notice.title)
        }
    }
    
    func fetchAttendance() async {
        guard let upcomingSession else { return }

        do {
            let _ = try await useCase.fetchAttendance(
                model: .init(sessionId: upcomingSession.sessionId, attendanceCode: otpText)
            )

            await loadSessionsAndUpcoming()

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
    
    func findTodaySession() async throws -> UpcomingSession? {
        // 유저의 기수 정보 조회
        let generation = await userStorage
            .loadUser()?
            .activityUnits
            .max { $0.generation < $1.generation }?
            .generation

        // 주간 세션 목록 조회
        let sessionsResponse = try await sessionUseCase.loadSessionsByHome(
            generation,
            Date.now.toString(.sessionDate),
            Calendar.current.date(byAdding: .day, value: 1, to: .now)?.toString(.sessionDate)
        )
        guard let sessionsResponse else { return nil }

        // 임박한 세션 찾기
        guard let targetSession = findUpcomingSession(from: sessionsResponse.data) else {
            return nil
        }

        // 세션 공지사항 조회
        let notices = try await loadNotices(sessionId: targetSession.id)
        
        return targetSession.toUpcomingSession(notices: notices)
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
