//
//  SessionAttendanceGridView.swift
//  yappu-world-ios
//
//  Created by 김도연 on 4/18/26.
//

import SwiftUI

struct SessionAttendanceGridView: View {

    let totalSessionCount: Int
    let histories: [AttendanceHistoryEntity]

    private let cellWidth: CGFloat = 40
    private let cellHeight: CGFloat = 32
    private let horizontalGap: CGFloat = 17
    private let verticalGap: CGFloat = 36
    private let topPadding: CGFloat = 27
    private let columnsPerRow = 5

    private var rows: [[Int]] {
        let indices = Array(0..<totalSessionCount)
        return stride(from: 0, to: indices.count, by: columnsPerRow).map {
            Array(indices[$0..<min($0 + columnsPerRow, indices.count)])
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(hex: "#F4F4F5"))

            VStack(spacing: verticalGap) {
                ForEach(rows.indices, id: \.self) { rowIndex in
                    HStack(spacing: horizontalGap) {
                        ForEach(rows[rowIndex], id: \.self) { index in
                        }
                    }
                }
            }
            .padding(.top, topPadding)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 290)
        .padding(.horizontal, 20)
    }
}

struct AttendanceStampCell: View {

    let sessionNumber: Int
    let status: String?

    private var labelText: String {
        guard let status else { return "\(sessionNumber)" }
        switch status {
        case "ON_TIME": return "출석"
        case "LATE": return "지각"
        case "ABSENT": return "결석"
        case "EXCUSED_ABSENCE": return "공결"
        case "EARLY_CHECK_OUT": return "조퇴"
        default: return "\(sessionNumber)"
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(.white)
                .opacity(0.7)

            Text(labelText)
                .font(.pretendard12(.semibold))
                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                .offset(y: 2)
        }
        .frame(width: 40, height: 32)
    }
}

#Preview {
    SessionAttendanceGridView(
        totalSessionCount: 17,
        histories: AttendanceHistoryEntity.dummies()
    )
    .padding(.horizontal, 20)
}
