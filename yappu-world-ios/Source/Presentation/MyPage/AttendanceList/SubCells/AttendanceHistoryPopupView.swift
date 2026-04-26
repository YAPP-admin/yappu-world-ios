//
//  AttendanceHistoryPopupView.swift
//  yappu-world-ios
//
//  Created by 김도연 on 4/26/26.
//

import SwiftUI

struct AttendanceHistoryPopupView: View {

    let history: AttendanceHistoryEntity
    var onDismiss: () -> Void

    private var badgeType: YPScheduleBadgeType {
        YPScheduleBadgeType(history.attendanceStatus ?? "")
    }

    private var showBadge: Bool {
        badgeType != .upcoming && badgeType != .none
    }

    private var sessionStartText: String {
        let date = history.startAt.toDate(.iso8601) ?? history.startAt.toDate(.history)
        return date?.toString(.attendanceDateTime) ?? "-"
    }

    private var checkedInText: String {
        guard let checkedInAt = history.checkedInAt else { return "-" }
        let date = checkedInAt.toDate(.iso8601) ?? checkedInAt.toDate(.history)
        return date?.toString(.attendanceDateTime) ?? "-"
    }

    // 상태에 따라 안내 문구 on/off
    private var noticeText: String? {
        switch history.attendanceStatus {
        case "ABSENT":
            return "세션 시작 2시간 내 출석하지 않았어요."
        case "LATE":
            return "세션 시작 10분 이후에 출석했어요."
        default:
            return nil
        }
    }

    var body: some View {
        VStack(spacing: 24) {
            // 타이틀 + 출석 상태 칩 (칩은 출석 데이터 있을 때만 노출)
            HStack(spacing: 8) {
                Text(history.title)
                    .font(.pretendard18(.semibold))
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))

                if showBadge {
                    YPScheduleBadge(type: badgeType)
                }

                Spacer()
            }
            .frame(minHeight: 26, alignment: .center)

            // 정보 행 + 안내 문구
            VStack(spacing: 12) {
                infoRow(label: "세션 시작 시간", value: sessionStartText)
                infoRow(label: "내가 출석한 시간", value: checkedInText)
            }
            
            if let notice = noticeText {
                Text(notice)
                    .font(.pretendard13(.medium))
                    .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                    .multilineTextAlignment(.center)
                    .kerning(0.2522)
                    .frame(minHeight: 18, alignment: .center)
                    .padding(.all, 10)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.yapp(.semantic(.fill(.alternative))))
                    )
            }

            // 닫기 버튼
            Button(action: onDismiss) {
                Text("닫기")
                    .font(.pretendard16(.medium))
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.yapp(
                font: .pretendard16(.medium),
                horizontalPadding: 28,
                verticalPadding: 12,
                style: .border(.secondary)
            ))
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.pretendard15(.medium))
                .kerning(0.144)
                .foregroundStyle(.yapp(.semantic(.label(.alternative))))

            Spacer()

            Text(value)
                .font(.pretendard15(.semibold))
                .kerning(0.144)
                .foregroundStyle(.yapp(.semantic(.label(.normal))))
        }
        .frame(minHeight: 22, alignment: .center)
    }
}

#Preview {
    VStack(spacing: 20) {
        // default: 출석 데이터 없음
        AttendanceHistoryPopupView(history: .dummyUpcoming(), onDismiss: {})

        // 출석
        AttendanceHistoryPopupView(history: .dummy(), onDismiss: {})

        // 지각 (안내 문구 노출)
        AttendanceHistoryPopupView(history: .dummyLate(), onDismiss: {})

        // 결석 (안내 문구 노출)
        AttendanceHistoryPopupView(history: .dummyAbsent(), onDismiss: {})
    }
    .padding(20)
}
