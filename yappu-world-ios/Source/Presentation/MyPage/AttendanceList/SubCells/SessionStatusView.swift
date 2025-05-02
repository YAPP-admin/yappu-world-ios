//
//  SessionStatusView.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import SwiftUI

struct SessionStatusView: View {
    
    var item: AttendanceStatisticEntity
    
    init(item: AttendanceStatisticEntity) {
        self.item = item
    }
    
    var body: some View {
        
        ZStack {
            backgroundView
            
            VStack(spacing: 0) {
                attendanceStatus

                ZStack {
                    Color.white
                        .foregroundStyle(.white)
                        .cornerRadius(radius: 8, corners: [.bottomLeft, .bottomRight])
                    
                    LazyHGrid(
                        rows: [GridItem()], spacing: 4) {
                            subCellView(title: "전체 세션", count: item.totalSessionCount)
                            subCellView(title: "남은 세션", count: item.remainingSessionCount)
                        }
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding([.bottom, .leading, .trailing], 1)
                
            }
        }
        .padding(.all, 20)
        .fixedSize(horizontal: false, vertical: true)
        
    }
}

extension SessionStatusView {
    var backgroundView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(.yapp(.semantic(.line(.alternative))), lineWidth: 1)
            
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.yapp(.semantic(.line(.alternative))))
        }
    }
    
    var attendanceStatus: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Text("세션 현황")
                .font(.pretendard14(.semibold))
                .foregroundStyle(.yapp(.semantic(.label(.normal))))
            
            Spacer()
            
            Text("진행률")
                .font(.pretendard13(.regular))
                .foregroundStyle(.yapp(.semantic(.label(.neutral))))
                .padding(.trailing, 6)
            
            ZStack(alignment: .bottom) {
                
                Rectangle()
                    .foregroundStyle(Color(hex: "#FFEFE9"))
                    .frame(height: 8)
                
                Text("\(item.sessionProgressRate)%")
                    .font(.pretendard15(.semibold))
                    .foregroundStyle(.yapp(.semantic(.primary(.normal))))
                    .padding(.bottom, 3)
                
            }
            .fixedSize()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
    
    func subCellView(title: String, count: Int) -> some View {
        
        let width = (UIScreen.main.bounds.width / 2) - 20
        
        return VStack(spacing: 2) {
            Text(title)
                .font(.pretendard12(.medium))
                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
            
            Text("\(count)번")
                .font(.pretendard14(.semibold))
                .foregroundStyle(.yapp(.semantic(.label(.normal))))
        }
        .frame(minWidth: width, minHeight: 75)
    }
}

#Preview {
    SessionStatusView(item: .dummy())
}
