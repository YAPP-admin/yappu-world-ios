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
    
    private let sessionList: [ScheduleEntity]
    
    init(scrollIndex: Binding<Int?>, sessionList: [ScheduleEntity]) {
        self._scrollIndex = scrollIndex
        self.sessionList = sessionList
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 4) {
                Image(.bell)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                
                Text("이번 기수 세션")
                    .font(.pretendard18(.bold))
                    .foregroundStyle(.yapp(.semantic(.static(.white))))
                
                Spacer()
                
                Button("전체보기") {
                    
                }
                .buttonStyle(.text(style: .normal, size: .small))
            }
            .padding(.horizontal, 20)
            
            activitySessionList
            
            scrollIndicator
        }
        .onAppear(perform: bodyOnAppear)
        .onChange(of: scrollIndex) { oldValue, newValue in
            print(oldValue, newValue)
        }
    }
}

// MARK: - Configure Views
private extension ActivitySessionSection {
    var activitySessionList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                ForEach(sessionList.indices, id: \.self) { index in
                    let session = sessionList[index]
                    let isDone = session.scheduleProgressPhase == .done
                    activitySessionListCell(session)
                        .opacity(isDone ? 0.6 : 1)
                        .id(index)
                }
            }
            .scrollTargetLayout()
            .padding(.top, 10)
            .padding(.bottom, 16)
        }
        .scrollPosition(id: $scrollIndex, anchor: .center)
        .contentMargins(
            scrollIndex == 0 ? .trailing : .horizontal,
            scrollIndex == 0 ? 88 : 44
        )
        .scrollTargetBehavior(.viewAligned)
    }
    
    @ViewBuilder
    func activitySessionListCell(_ item: ScheduleEntity) -> some View {
        let phase = item.scheduleProgressPhase ?? .pending
        
        VStack(alignment: .leading, spacing: 4) {
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
            
            let time = item.time?.convertDateFormat(
                from: .sessionTime,
                to: .activitySessionTime
            ) ?? ""
            let endTime = item.endTime?.convertDateFormat(
                from: .sessionTime,
                to: .activitySessionTime
            ) ?? ""
            sessionInfoCell(
                image: .history,
                content: "\(time) - \(endTime)"
            )
        }
        .padding(12)
        .frame(height: 120)
        .containerRelativeFrame(
            .horizontal,
            count: 1,
            span: 1,
            spacing: 8,
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
    
    @ViewBuilder
    var scrollIndicator: some View {
        let isMoreThanFour = sessionList.count >= 4
        let range = isMoreThanFour ? 0..<3 : 0..<sessionList.count - 1
        
        HStack(spacing: 8) {
            ForEach(range, id: \.self) { index in
                scrollIndicatorDot(pivot: Double(index))
            }
            .frame(width: 8, height: 8)
            
            scrollIndicatorDot(pivot: isMoreThanFour ? 3 : Double(sessionList.count) - 1)
                .frame(width: 6, height: 6)
        }
        .animation(.smooth, value: scrollIndex)
    }
     
    @ViewBuilder
    func scrollIndicatorDot(pivot: Double) -> some View {
        let index = Double(scrollIndex ?? 0)
        let isMoreThanFour = sessionList.count >= 4
        let divider = isMoreThanFour ? 3 : Double(sessionList.count) - 1
        let length = Double(sessionList.count - 1)
        let isActive = length / divider * pivot <= index && index < length / divider * (pivot + 1)
        let color: Color = .yapp(.semantic(.static(.white))).opacity(
            isActive ? 1 : 0.16
        )
        
        Circle().fill(color)
    }
}

// MARK: - Functions
private extension ActivitySessionSection {
    func bodyOnAppear() {
        var currentIndex = sessionList.firstIndex(where: { session in
            session.scheduleProgressPhase == .today
        })
        if currentIndex == nil {
            currentIndex = sessionList.firstIndex(where: { session in
                session.scheduleProgressPhase == .upcoming
            })
        }
        withAnimation {
            scrollIndex = currentIndex
        }
    }
}

private extension ScheduleEntity.ProgressPhase {
    var color: Color {
        switch self {
        case .done, .pending: return .coolNeutral50
        case .upcoming: return .yapp(.semantic(.secondary(.normal)))
        case .today: return .yapp(.semantic(.primary(.normal)))
        }
    }
    
    var title: String {
        switch self {
        case .done: return "완료"
        case .pending: return "보류"
        case .today: return "당일"
        case .upcoming: return "임박"
        }
    }
}

#Preview {
    @Previewable
    @State var scrollIndex: Int?
    
    ActivitySessionSection(
        scrollIndex: $scrollIndex,
        sessionList: ScheduleEntity.mockList
    )
    .fixedSize(horizontal: false, vertical: true)
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
