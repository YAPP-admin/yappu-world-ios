//
//  HomeAttendView.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/16/25.
//

import SwiftUI

struct HomeAttendView: View {
    
    var upcomingSession: UpcomingSession?
    var upcomingState: UpcomingSessionAttendanceState

    private var attendanceButtonAction: (() -> Void)?

    init(upcomingSession: UpcomingSession?, upcomingState: UpcomingSessionAttendanceState, attendanceButtonAction: (() -> Void)? = nil) {
        self.upcomingSession = upcomingSession
        self.upcomingState = upcomingState
        self.attendanceButtonAction = attendanceButtonAction
    }
    
    var body: some View {
        VStack(spacing: 12) {
            NoticeBanner(text: upcomingState.banner)
            AttendanceCard()
        } // VStack
        .padding(.horizontal, 20)
        .background(.white)
    }
}
// MARK: - Private UI Builders
private extension HomeAttendView {
    
    func NoticeBanner(text: String) -> some View {
        HStack(spacing: 4) {
            Image("loudSpeaker")
            Text(text)
                .font(.pretendard12(.medium))
                .foregroundStyle(.labelGray)
        }
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
        .background(Color.activetyCellBackgroundColor)
        .cornerRadius(10)
    }
    
    @ViewBuilder
    func AttendanceCard() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if upcomingState == .NoSession {
                Text("모든 세션이 종료되었어요.\n기수 활동에 참여해 주셔서 감사합니다 :)")
                    .font(.pretendard12(.medium))
                    .foregroundStyle(.gray60)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity)
            } else {
                if let upcomingSession = upcomingSession {
                    // 세션 제목
                    let sessionTitle: String = {
                        if case .Inactive_Yet = upcomingState {
                            return "오늘은 \(Date().formatted(as: "MM월 dd일이에요."))"
                        } else {
                            return upcomingSession.name
                        }
                    }()
                    
                    Text(sessionTitle)
                        .font(.pretendard13(.medium))
                        .foregroundStyle(.labelGray)
                    
                    // 시간 정보
                    if upcomingState == .Inactive_Dday || upcomingState == .Attended || upcomingState == .Available {
                        HStack(spacing: 4) {
                            HStack(spacing: 4) {
                                Image("clock")
                                
                                if let startTime = upcomingSession.startTime, let endTime = upcomingSession.endTime {
                                    Text(upcomingState == .Attended ? "\(endTime.toTimeFormat(as: "a h시 mm분")) 종료" :  "\(startTime.toTimeFormat(as: "a h시 mm분")) 오픈")
                                        .font(.pretendard14(.medium))
                                        .foregroundStyle(.yapp_primary)
                                }
                            }
                            
                            Spacer()
                            
                            if upcomingState == .Attended {
                                Text("진행중")
                                    .font(.pretendard11(.medium))
                                    .foregroundStyle(.common100)
                                    .frame(height: 14)
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 8)
                                    .background(.coolNeutral50)
                                    .clipRectangle(6)
                                
                                if let startTime = upcomingSession.startTime {
                                    Text("\(startTime.prefix(5))~")
                                        .font(.pretendard13(.medium))
                                        .foregroundStyle(.labelGray)
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                    
                    if let attendanceButtonAction {
                        // 출석 버튼
                        Button(action: {
                            attendanceButtonAction()
                        }) {
                            Text(upcomingState.button)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(upcomingState == .Attended ? .yapp(radius: 8, style: .custom(fg: .yapp(.semantic(.primary(.normal))), bg: .orange95)) : .yapp(radius: 8, style: .primary))
                        .disabled(upcomingState.isDisabled)
                        .padding(.top, 12)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                .foregroundColor(Color.yapp(.semantic(.primary(.normal))))
        )
    }
}

#Preview {
    HomeAttendView(upcomingSession: .dummy(), upcomingState: .Attended, attendanceButtonAction: {
        
    })
}
