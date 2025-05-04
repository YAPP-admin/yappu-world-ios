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
    
    var histories: [ScheduleEntity]
    
    init(title: String = "세션 출석 내역", titleFont: Pretendard.Style = .pretendard16(.semibold), histories: [ScheduleEntity], moreButtonAction: (() -> Void)? = nil) {
        self.title = title
        self.titleFont = titleFont
        self.histories = histories
        self.moreButtonAction = moreButtonAction
    }
    
    var body: some View {
        
        VStack {
            
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
            
            
            LazyVGrid(columns: [.init()], content: {
                if histories.isEmpty {
                    Text("아직 출석 내역이 없어요.")
                        .font(.pretendard13(.regular))
                        .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                        .padding(.vertical, 12)
                } else {
                    ForEach(histories, id:\.id) { data in
                        let item = data.toCellData(isToday: false, viewType: .flat)
                        YPScheduleCell(model: item, isLast: histories.last?.id == data.id)
                            .tag(data.id)
                            .id(data.id)
                    }
                    .padding(.horizontal, 20)
                }
                
            })
        }
        
        
    }
}

#Preview {
    SessionAttendanceListView(histories: [.dummy()], moreButtonAction: {
        
    })
}
