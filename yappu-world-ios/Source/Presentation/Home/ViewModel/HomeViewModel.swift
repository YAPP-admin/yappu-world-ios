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
    
//    var profile: Profile? = nil
    var upcomingSession: UpcomingSession? = nil

//    var noticeList: [NoticeEntity] = [.loadingDummy(), .loadingDummy(), .loadingDummy()]
    
    var attendanceHistories: [ScheduleEntity] = [.dummy(), .dummy(), .dummy()]
    
    var isAttendDisabled: Bool = false
    
    var isSheetOpen: Bool = false
    var otpText: String = ""
    var otpState: InputState = .typing
    var isInvalid: Bool = false
    var otpCount: Int = 4
    
//    var isLoading: Bool {
//       profile == nil
//    }
    
    func resetState() {
//        profile = nil
        upcomingSession = nil
    }
    
    func onTask() async throws {
        do {
//            try await loadProfile()
//            try await loadNoticeList()
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
//                self.profile = .dummy()
//                self.noticeList = []
            }
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
//    private func loadProfile() async throws {
//        
//        guard profile == nil else { return }
//        
//        let profileResponse = try await useCase.loadProfile()
//        await self.userStorage.save(user: profileResponse.data)
//        await MainActor.run {
//            self.profile = profileResponse.data
//        }
//    }
    
//    private func loadNoticeList() async throws {
//        let noticeResponse = try await noticeUseCase.loadNotices(model: .init(lastCursorId: nil, limit: 3, noticeType: "ALL"))
//        
//        await MainActor.run {
//            if let notices = noticeResponse?.data {
//                self.noticeList = notices.data.map({ $0.toEntity() })
//            }
//        }
//    }
    
    private func loadUpcomingSession() async throws {
        
        guard upcomingSession == nil else { return }

        let upcomingSessionsResponse = try await useCase.loadUpcomingSession()
        
        await MainActor.run {
            self.upcomingSession = upcomingSessionsResponse.data
        }
    }
    
    private func fetchAttendance() async {
        guard let upcomingSession = upcomingSession else { return }
        
        do {
            let _ = try await useCase.fetchAttendance(
                model: .init(sessionId: upcomingSession.sessionId, attendanceCode: otpText) // sessionId 임시
            )
            self.reset() // 닫기
        } catch {
            guard let ypError = error as? YPError else { return }
            switch ypError.errorCode {
            case "ATD_1001":
                otpState = .error("출석코드가 일치하지 않습니다. 다시 확인해주세요")
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
