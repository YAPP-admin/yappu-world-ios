//
//  SessionAttendanceListView.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import SwiftUI

struct SessionAttendanceListView: View {
    private var title: String
    private var titleFont: Pretendard.Style

    var histories: [AttendanceHistoryEntity]

    @State private var selectedHistory: AttendanceHistoryEntity? = nil

    init(title: String = "📢 세션 출석 내역", titleFont: Pretendard.Style = .pretendard17(.semibold), histories: [AttendanceHistoryEntity]) {
        self.title = title
        self.titleFont = titleFont
        self.histories = histories
    }

    var body: some View {

        VStack(spacing: 0) {

            HStack {
                InformationLabel(title: title, titleFont: titleFont)
                    .padding(.horizontal, 20)

                Spacer()
            }
            .padding(.bottom, 12)


            VStack(spacing: 0) {
                if histories.isEmpty {
                    Text("아직 출석 내역이 없어요.")
                        .font(.pretendard13(.regular))
                        .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                        .padding(.vertical, 20)
                } else {
                    let filtered = histories.filter {
                        let badge = YPScheduleBadgeType($0.attendanceStatus ?? "")
                        return badge != .upcoming && badge != .none
                    }
                    ForEach(filtered.indices, id: \.self) { index in
                        AttendanceHistoryCell(history: filtered[index]) {
                            selectedHistory = filtered[index]
                            print("[SessionAttendanceListView] tapped: \(filtered[index].title)")
                        }
                        .padding(.horizontal, 20)
                        if index < filtered.count - 1 {
                            YPDivider(color: .yapp(.semantic(.line(.alternative))))
                                .padding(.horizontal, 20)
                        }
                    }
                }
            }
        }
    }
}

struct AttendanceHistoryCell: View {
    let history: AttendanceHistoryEntity
    var onTap: (() -> Void)?

    private var dateText: String {
        let date = history.startAt.toDate(.iso8601) ?? history.startAt.toDate(.history)
        guard let date else { return history.startAt }
        return date.toString(.attendanceDateTime) + " 시작"
    }

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(history.title)
                        .font(.pretendard15(.semibold))
                        .foregroundStyle(.yapp(.semantic(.label(.normal))))

                    if let status = history.attendanceStatus {
                        let badgeType = YPScheduleBadgeType(status)
                        if badgeType != .upcoming && badgeType != .none {
                            YPScheduleBadge(type: badgeType)
                        }
                    }
                }

                Text(dateText)
                    .font(.pretendard13(.regular))
                    .foregroundStyle(.yapp(.semantic(.label(.alternative))))
            }

            Spacer()

            Image("chevronRight_Tight_Small")
                .resizable()
                .frame(width: 12, height: 24)
        }
        .padding(.vertical, 16)
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
    }
}

#Preview {
    SessionAttendanceListView(histories: AttendanceHistoryEntity.dummies())
}
