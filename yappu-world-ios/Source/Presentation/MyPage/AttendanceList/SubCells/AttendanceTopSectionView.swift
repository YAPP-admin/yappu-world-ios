//
//  AttendanceTopSectionView.swift
//  yappu-world-ios
//
//  Created by 김도연 on 4/18/26.
//

import SwiftUI

struct AttendanceTopSectionView: View {
    var item: AttendanceStatisticEntity
    var sessionList: [AttendanceHistoryEntity]
    
    init(item: AttendanceStatisticEntity, sessionList: [AttendanceHistoryEntity]) {
        self.item = item
        self.sessionList = sessionList
    }
    
    var body: some View {
        VStack(spacing: 16) {
            coloredText(
                "세션 종료까지 \(item.remainingSessionCount)번 남았어요",
                  highlights: [("\(item.remainingSessionCount)번", .yapp(.semantic(.primary(.normal))))],
                  defaultColor: .yapp(.semantic(.label(.normal)))
              )
              .font(.pretendard17(.semibold))
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.top, 24)
              .padding(.horizontal, 20)

            VStack(alignment: .center, spacing: 8) {
                AttendanceStatusView(item: item)
                
                SessionAttendanceGridView(
                    totalSessionCount: item.totalSessionCount,
                    histories: sessionList
                )
            }
            
        }
    }
}

#Preview {
    AttendanceTopSectionView(item: .dummy(), sessionList: AttendanceHistoryEntity.dummies())
}
