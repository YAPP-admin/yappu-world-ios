//
//  AttendanceStatusView.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/2/25.
//

import SwiftUI

struct AttendanceStatusView: View {
    
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
                        rows: [GridItem()], spacing: 3) {
                            subCellView(title: "지각", count: item.lateCount)
                            subCellView(title: "결석", count: item.absenceCount)
                            subCellView(title: "지각 면제권", count: item.latePassCount)
                        }
                        .padding(4)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding([.bottom, .leading, .trailing], 1)
                
            }
        }
        .padding(.horizontal, 20)
        .fixedSize(horizontal: false, vertical: true)
        
    }
}


extension AttendanceStatusView {
    
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
            Text("내 출석 현황")
                .font(.pretendard14(.semibold))
                .foregroundStyle(.yapp(.semantic(.label(.normal))))
            
            attendanceChipView(point: item.attendancePoint)
            
            Spacer()
            
            Text("총 점수")
                .font(.pretendard13(.regular))
                .foregroundStyle(.yapp(.semantic(.label(.neutral))))
                .padding(.trailing, 6)
            
            ZStack(alignment: .bottom) {
                
                Rectangle()
                    .foregroundStyle(Color(hex: "#FFEFE9"))
                    .frame(height: 8)
                
                Text("\(item.attendancePoint)점")
                    .font(.pretendard15(.semibold))
                    .foregroundStyle(.yapp(.semantic(.primary(.normal))))
                    .padding(.bottom, 3)
                
            }
            .fixedSize()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func attendanceChipView(point: Int) -> some View {
        switch point {
        case 90...:
            YPChip("양호")
                .color(.lime)
                .size(.small)
                .padding(.horizontal, 8)
        case 70..<90:
            YPChip("주의")
                .color(.yellow)
                .size(.small)
                .padding(.horizontal, 8)
        case ..<70 :
            YPChip("미이수")
                .color(.red)
                .size(.small)
                .padding(.horizontal, 8)
        default:
            // 예외 디버깅용
            YPChip("해당 없음")
                .color(.neutral)
                .size(.small)
                .padding(.horizontal, 8)
        }
    }

    func subCellView(title: String, count: Int) -> some View {
        
        let width = (UIScreen.main.bounds.width - 56) / 3
        
        return VStack(spacing: 2) {
            Text(title)
                .font(.pretendard12(.medium))
                .foregroundStyle(.yapp(.semantic(.label(.alternative))))
            
            Text("\(count)")
                .font(.pretendard14(.semibold))
                .foregroundStyle(.yapp(.semantic(.label(.normal))))
        }
        .padding(.vertical, 10)
        .frame(minWidth: width, alignment: .center)
    }
}

#Preview {
    ZStack {
        //Color.red.opacity(0.2)
        AttendanceStatusView(item: .dummy())
    }
    
}
