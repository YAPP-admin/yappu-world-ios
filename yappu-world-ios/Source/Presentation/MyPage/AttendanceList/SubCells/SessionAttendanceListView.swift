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
    private var moreButtonAction: (() -> Void)?

    var histories: [AttendanceHistoryEntity]

    init(title: String = "세션 출석 내역", titleFont: Pretendard.Style = .pretendard16(.semibold), histories: [AttendanceHistoryEntity], moreButtonAction: (() -> Void)? = nil) {
        self.title = title
        self.titleFont = titleFont
        self.histories = histories
        self.moreButtonAction = moreButtonAction
    }

    var body: some View {

        VStack(spacing: 0) {

            HStack {
                InformationLabel(title: title, titleFont: titleFont)
                    .padding(.horizontal, 20)

                Spacer()

                if let moreButtonAction {
                    Button(action: {
                        moreButtonAction()
                    }, label: {
                        Text("전체 보기")
                            .font(.pretendard14(.semibold))
                            .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                    })
                    .padding(.trailing, 20)
                }
            }
            .padding(.bottom, 8)


            VStack(spacing: 0) {
                if histories.isEmpty {
                    Text("아직 출석 내역이 없어요.")
                        .font(.pretendard13(.regular))
                        .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                        .padding(.vertical, 20)
                } else {
                    ForEach(histories) { history in
                        AttendanceHistoryCell(
                            history: history,
                            isLast: histories.last?.id == history.id
                        )
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct AttendanceHistoryCell: View {
    let history: AttendanceHistoryEntity
    let isLast: Bool

    private var attributedText: AttributedString {
        var nameText = AttributedString(history.name)
        nameText.foregroundColor = .yapp(.semantic(.label(.neutral)))

        if let checkedInAt = history.checkedInAt?.convertDateFormat(
            from: .iso8601,
            to: .scheduleCellTime
        ) {
            var separatorText = AttributedString(" " + checkedInAt)
            separatorText.foregroundColor = .yapp(.semantic(.label(.alternative)))
            return nameText + separatorText
        }

        return nameText
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Text(attributedText)
                    .frame(maxWidth: .infinity, alignment: .leading)

                YPScheduleBadge(type: YPScheduleBadgeType(history.attendanceStatus))
            }
            .font(.pretendard13(.regular))
            .padding(.vertical, 14)

            if !isLast {
                YPDivider(color: .yapp(.semantic(.line(.alternative))))
            }
        }
    }
}

#Preview {
    SessionAttendanceListView(histories: [.dummy(), .dummy()], moreButtonAction: {

    })
}
