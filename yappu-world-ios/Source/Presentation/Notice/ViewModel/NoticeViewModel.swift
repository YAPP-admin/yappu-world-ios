//
//  NoticeViewModel.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import Foundation
import Dependencies

@Observable
class NoticeViewModel {
    
    
    @ObservationIgnored
    @Dependency(NoticeUseCase.self)
    private var useCase
    
    private var currentPage: NoticeRequest = .init(page: 1, size: 30, displayTarget: "활동회원")
    private var isLoading: Bool = false
    private var isLastPage: Bool = false
    
    var notices: [NoticeEntity] = [
//        .dummy(),
//        .dummy(),
//        .dummy(),
//        .dummy(),
//        .dummy(),
//        .dummy(),
//        .dummy(),
//        .dummy(),
//        .dummy(),
//        .dummy(),
//        .dummy(),
//        .dummy(),
//        .dummy(),
//        .dummy(),
//        .dummy(),
//        .dummy()
    ]
    
    var selectedNoticeList: NoticeType = .전체
    
    func loadNotices() async throws {
        
        guard isLastPage == false else { return }
        
        let datas = try await useCase.loadNotices(model: currentPage)
        
        if let loadNotices = datas?.content.map({ $0.toEntity() }) {
            notices.append(contentsOf: loadNotices)
        }
        
        if datas?.last == false {
            currentPage.page += 1
        } else {
            isLastPage = true
        }
        
    }
    
}

