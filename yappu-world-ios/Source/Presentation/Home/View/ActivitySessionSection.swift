//
//  ActivitySessionSection.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/3/25.
//

import Foundation

import SwiftUI

struct ActivitySessionSection: View {
    @Binding
    private var scrollIndex: Int?
    
    @State
    private var isIncrease: Bool = false
    
    private let sessionList: [ScheduleEntity]
    private let allSessionButtonAction: () -> Void
    
    init(
        scrollIndex: Binding<Int?>,
        sessionList: [ScheduleEntity],
        action: @escaping () -> Void
    ) {
        self._scrollIndex = scrollIndex
        self.sessionList = sessionList
        self.allSessionButtonAction = action
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 4) {
                Image(.bell)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                
                Text("이번 달 세션")
                    .font(.pretendard18(.bold))
                    .foregroundStyle(.yapp(.semantic(.static(.white))))
                
                Spacer()
                
                Button("전체보기", action: allSessionButtonAction)
                    .buttonStyle(.text(style: .normal, size: .small))
            }
            .padding(.horizontal, 20)
            
            YPCarousel(
                scrollIndex: $scrollIndex,
                isIncrease: $isIncrease,
                items: sessionList
            ) { item in
                activitySessionListCell(item)
                    .opacity(item.scheduleProgressPhase == .done ? 0.6 : 1)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .onChange(of: sessionList) { _, _ in
            sessionListOnChange()
        }
        .onChange(of: scrollIndex, scrollIndexOnChange)
    }
}

// MARK: - Configure Views
private extension ActivitySessionSection {

    func activitySessionListCell(_ item: ScheduleEntity) -> some View {
        var phase = item.scheduleProgressPhase ?? .pending
        if phase == .done && item.relativeDays ?? 0 < 0 {
            phase = .pending
        }
        
        return VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Text(phase.title)
                    .font(.pretendard11(.medium))
                    .foregroundStyle(.common100)
                    .frame(height: 14)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 8)
                    .background(phase.color)
                    .clipRectangle(6)
                
                Text(item.name)
                    .font(.pretendard16(.semibold))
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))
            }
            
            let date = item.date?.convertDateFormat(
                from: .sessionDate,
                to: .activitySessionDate
            ) ?? ""
            
            Text(date)
                .font(.pretendard12(.medium))
                .foregroundStyle(.yapp(.semantic(.label(.neutral))))
            
            Spacer()
            
            sessionInfoCell(
                image: .location,
                content: item.place ?? ""
            )
            
            let time = item.time?
                .toDate(.sessionTime)?
                .getCurrentTimeString() ?? ""
            let endTime = item.endTime?
                .toDate(.sessionTime)?
                .getCurrentTimeString() ?? ""
            sessionInfoCell(
                image: .history,
                content: "\(time) - \(endTime)"
            )
        }
        .padding(12)
        .frame(height: 120)
        .containerRelativeFrame(
            .horizontal,
            alignment: .leading
        )
        .background(.yapp(.semantic(.background(.normal(.normal)))))
        .clipRectangle(10)
        .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 4)
        .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 6)
    }
    
    func sessionInfoCell(image: ImageResource, content: String) -> some View {
        HStack(spacing: 4) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
            
            Text(content)
                .font(.pretendard12(.regular))
        }
        .foregroundStyle(.yapp(.semantic(.interaction(.inactive))))
    }
}

// MARK: - Functions
private extension ActivitySessionSection {
    func sessionListOnChange() {
        guard sessionList.isEmpty.not() else { return }
        var currentIndex = sessionList.firstIndex(where: { session in
            session.scheduleProgressPhase == .today
        })
        if currentIndex == nil {
            currentIndex = sessionList.firstIndex(where: { session in
                session.scheduleProgressPhase == .pending
            })
        }
        withAnimation {
            scrollIndex = currentIndex
        }
    }
    
    func scrollIndexOnChange(_ oldValue: Int?, _ newValue: Int?) {
        isIncrease = oldValue ?? 0 < newValue ?? 0
    }
}

#Preview {
    @Previewable
    @State var scrollIndex: Int?
    
    ActivitySessionSection(
        scrollIndex: $scrollIndex,
        sessionList: ScheduleEntity.mockList
    ) {
        
    }
    .padding(.vertical)
    .background(
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 1, green: 0.68, blue: 0.19), location: 0.00),
                Gradient.Stop(color: Color(red: 0.98, green: 0.38, blue: 0.15), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0),
            endPoint: UnitPoint(x: 1.06, y: 1.39)
        )
    )
}
