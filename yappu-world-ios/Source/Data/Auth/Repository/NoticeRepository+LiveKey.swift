//
//  NoticeRepository.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/24/25.
//

import Foundation
import Dependencies

extension NoticeRepository: DependencyKey {
    static var liveValue: NoticeRepository = {
        
        let networkClient = NetworkClient<NoticeEndPoint>.build()
        
        return NoticeRepository(
            loadNoticeList: { model in
                let response: NoticeResponse = try await networkClient
                    .request(endpoint: .loadNoticeList(model))
                    .response()
                
                return response
            },
            loadNoticeDetail: { id in
                let response: NoticeResponse = try await networkClient
                    .request(endpoint: .loadNoticeDetail(noticeId: id))
                    .response()
                
                return response
            }
        )
            
    }()
}
