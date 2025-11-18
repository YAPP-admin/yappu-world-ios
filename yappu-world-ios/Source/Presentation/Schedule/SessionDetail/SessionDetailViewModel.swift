//
//  SessionDetailViewModel.swift
//  yappu-world-ios
//
//  Created by 김건형 on 9/26/25.
//

import Foundation
import SwiftUI
import Dependencies
import DependenciesMacros

@Observable
class SessionDetailViewModel {
    @ObservationIgnored
    @Dependency(Navigation<TabViewGlobalPath>.self)
    var navigation
    
    @ObservationIgnored
    @Dependency(\.userStorage)
    private var userStorage
    
    @ObservationIgnored
    @Dependency(SessionUseCase.self)
    private var useCase
    
    @ObservationIgnored
    @Dependency(NoticeUseCase.self)
    private var noticeUseCase
    
    var id: String // 세션 Id
    var isSkeleton: Bool = true
    var sessionEntity: SessionDetailEntity? = .dummy()
    var showCopiedToast: Bool = false

    // Private Property
    private var isInit: Bool = false // 첫 화면이면 더이상 가져오지 않기

    init(id: String, entity: SessionDetailEntity? = nil) {
        self.id = id
        if let entity = entity {
            self.sessionEntity = entity
            self.isSkeleton = false
            self.isInit = true
        }
    }
}
// MARK: - User Action
extension SessionDetailViewModel {
    
    func onTask() async {
        guard isInit.not() else { return }
        
        do {
            try await loadSessionDetail()
            isInit = true
        } catch {
            await errorAction(error)
        }
    }
    
    /// 지도/주소 복사하기
    func clickMapItem(item: SessionTopSection.ActionItem) {
        // 세션의 위치 데이터 꺼내기
        let name = sessionEntity?.place ?? "위치"
        let address = sessionEntity?.address ?? ""
        let lat = sessionEntity?.latitude ?? 37.5665
        let lng = sessionEntity?.longitude ?? 126.9780
        
        // 경로/쿼리 각각에 맞는 인코딩
        let encodedQuery = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        let encodedPath: String = {
            var base = URL(string: "https://dummy.host")!
            base.appendPathComponent(name)
            return base.lastPathComponent
        }()
        
        // "실제 위치 정보가 있는지" 판단
        let hasValidCoordinate: Bool = {
            guard let session = sessionEntity else { return false }
            // 주소가 있으면 일단 위치가 있다고 본다
            if !session.address.isEmpty { return true }
            // 좌표가 (0,0)이면 없는 걸로 취급
            if session.latitude == 0 && session.longitude == 0 { return false }
            return true
        }()
        
        // 공용 오프너
        func open(_ urlString: String) {
            guard let url = URL(string: urlString) else { return }
            UIApplication.shared.open(url)
        }
        
        switch item {
        case .kakao_map:
            if !hasValidCoordinate {
                // 위치 정보가 없으면: 카카오맵만 열어서 현재 위치/기본 화면 보여주기
                if let appURL = URL(string: "kakaomap://open"),
                   UIApplication.shared.canOpenURL(appURL) {
                    UIApplication.shared.open(appURL)
                    return
                }
                // 앱 없으면 모바일 웹 기본 화면
                open("http://m.map.kakao.com/scheme/open")
                return
            }
            
            // 앱 우선 (좌표 중심 보기)
            if let appURL = URL(string: "kakaomap://look?p=\(lat),\(lng)"),
               UIApplication.shared.canOpenURL(appURL) {
                UIApplication.shared.open(appURL); return
            }
            open("https://map.kakao.com/link/map/\(encodedPath),\(lat),\(lng)")

        case .naver_map:
            // iOS도 검색 스킴 지원 → 안드로이드와 유사하게 맞출 수 있음
            let appname = Bundle.main.bundleIdentifier ?? "app"

            if let appURL = URL(string: "nmap://place?lat=\(lat)&lng=\(lng)&name=\(encodedQuery)&appname=\(appname)"),
               UIApplication.shared.canOpenURL(appURL) {
                UIApplication.shared.open(appURL); return
            }

            if let appURL = URL(string: "nmap://search?query=\(encodedQuery)&appname=\(appname)"),
               UIApplication.shared.canOpenURL(appURL) {
                UIApplication.shared.open(appURL); return
            }
            open("https://map.naver.com/v5/search/\(encodedPath)?c=\(lng),\(lat),17,0,0,0,d")

        case .copy_location:
            UIPasteboard.general.string = address
            self.showCopiedToast = true
        }
    }
    
    func clickBackButton() {
        navigation.pop()
    }
    
    // 공지사항 클릭
    func clickNoticeDetail(id: String) {
        navigation.push(path: .noticeDetail(id: id))
    }
}
// MARK: - Private Async Methods
private extension SessionDetailViewModel {
    // 세션 상세 조회
    func loadSessionDetail() async throws {
        let sessionResponse = try await useCase.loadSessionDetail(sessionId: id)
        
        await MainActor.run {
            if let sessionResponse = sessionResponse {
                sessionEntity = sessionResponse.data
                
                if isSkeleton {
                    isSkeleton = false
                }
            }
        }
    }
    
    func errorAction(_ error: Error) async {
        print(error.localizedDescription)
        await MainActor.run {
            YPGlobalPopupManager.shared.show()
            sessionEntity = nil
            isSkeleton = false
        }
    }
}
