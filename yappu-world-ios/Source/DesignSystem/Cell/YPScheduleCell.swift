//
//  YPScheduleCell.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/19/25.
//

import SwiftUI

enum YPScheduleCellViewType {
    case normal
    case flat
}

struct YPScheduleModel: Hashable, Equatable {
    var viewType: YPScheduleCellViewType
    var badgeType: YPScheduleBadgeType
    var isToday: Bool
    var task: YPScheduleTaskModel?
}

struct YPScheduleTaskModel: Hashable, Equatable {
    var title: String
    var message: String
}

struct YPScheduleCell: View {
    
    let item: YPScheduleModel
    let isLast: Bool
    
    init(item: YPScheduleModel, isLast: Bool = false) {
        self.item = item
        self.isLast = isLast
    }
    
    var body: some View {
        switch item.viewType {
        case .normal: normalTypeView
        case .flat: flatTypeView
        }
    }
}

extension YPScheduleCell {
    var normalTypeView: some View {
        VStack {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("6 (금)")
                    .font(.pretendard14(.semibold))
                    .foregroundStyle(item.isToday ? .yapp(.semantic(.primary(.normal))) : .yapp(.semantic(.label(.normal))))
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("세션명 표기")
                        .font(.pretendard14(.semibold))
                        .padding(.bottom, 6)
                    
                    HStack(spacing: 4) {
                        Image("location_icon")
                        Text("공덕 창업허브")
                            .font(.pretendard12(.regular))
                            .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                    }
                    
                    
                    HStack(spacing: 4) {
                        Image("time_icon")
                        Text("오후 6시 - 오후 8시")
                            .font(.pretendard12(.regular))
                            .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                    }
                    .padding(.top, 4)
                    
                    if let task = item.task {
                        VStack(alignment: .leading, spacing : 6) {
                            Text(task.title)
                                .font(.pretendard14(.semibold))
                                .foregroundStyle(.yapp(.semantic(.label(.normal))))
                            Text(task.message)
                                .font(.pretendard12(.regular))
                                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                        }
                        .padding(.top, 12)
                    }
                }
                
                Spacer()
                
                YPScheduleBadge(type: .attendance)
            }
            .padding(.bottom, 16)
            
            if isLast.not() {
                YPDivider(color: .yapp(.semantic(.line(.alternative))))
            }
        }
        
    }
}

extension YPScheduleCell {
    var flatTypeView: some View {
        Text("Hello")
    }
}

#Preview {
    YPScheduleCell(item: .init(viewType: .normal, badgeType: .attendance, isToday: true, task: .init(title: "과제명", message: "상세내용dasasddasadsadsadsadsadsadsadsadsasdasdadsadsdasadsasdadsdasadsadssadsadsadasdasdasdasdasddsadsadsada")))
        .padding(.horizontal, 20)
}
