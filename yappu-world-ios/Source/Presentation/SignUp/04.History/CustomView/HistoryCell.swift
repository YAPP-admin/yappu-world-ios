//
//  HistoryCell.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/27/25.
//

import SwiftUI

struct HistoryCell: View {
    typealias RegisterHistory = SignUpInfoEntity.RegisterHistory
    typealias Position = SignUpInfoEntity.RegisterHistory.Position
    
    var globalAnimation: Animation = .smooth(duration: 0.2)
    
    var sheetData: [Position] = [
        .PM,
        .UIUX_Design,
        .Android,
        .iOS,
        .Web,
        .Server
    ]
    
    @Binding var history: RegisterHistory
    @Binding var overlayHeight: CGFloat
    @State var currentHeight: CGFloat = 0
    
    @FocusState var isFocused
    @State var isSelected: Bool = false {
        didSet {
            clickUpdate()
        }
    }
    @State var rotateDegrees: Double = 0
    
    var deleteAction: ((RegisterHistory) -> ())?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if history.old {
                HStack {
                    Text("이전 기수 \(history.id)")
                        .foregroundStyle(.labelGray)
                        .font(.pretendard16(.bold))
                    
                    Spacer()
                    
                    Image("Normal_trash")
                        .padding(.all, 1)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            deleteAction?(history)
                        }
                }
                
            }
            
            HStack(spacing: 20) {
                YPTextFieldView(textField: {
                    
                    TextField("", text: $history.generation)
                        .textFieldStyle(.yapp(state: $history.state))
                        .focused($isFocused)
                    
                }, state: $history.state, headerText: "기수")
                .frame(maxWidth: 130)

                SectionView(content: {
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSelected ? .yapp_primary : history.position != nil ? .gray52 : .gray22 , lineWidth: 1)
                        
                        HStack {
                            Text(history.position == nil ? "선택해주세요" : "\(history.position?.rawValue ?? "")")
                                .font(.pretendard16(.regular))
                                .foregroundStyle(isSelected ? .labelGray : history.position == nil ? .gray22 : .labelGray)
                            
                            Spacer()
                            
                            Image(isSelected ? "_Icons_Responsive_ON" : "_Icons_Responsive")
                                .rotationEffect(isSelected ? .degrees(rotateDegrees) : .degrees(rotateDegrees))
                        }
                        .padding(.horizontal, 16)
                    }
                    .frame(height: 53)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(globalAnimation) {
                            isSelected.toggle()
                        }
                    }
                    .overlay(alignment: .top) {
                        dropDownSheet
                            .offset(x: 0, y: isSelected ? 58 : 56)
                            .opacity(isSelected ? 1 : 0)
                            .zIndex(Double(history.id))
                            .overlay(
                                GeometryReader { geometry in
                                    Color.clear
                                        .preference(key: HeightPreferenceKey.self,
                                                    value: geometry.size.height)
                                }
                            )
                            .onPreferenceChange(HeightPreferenceKey.self) { height in
                                overlayHeight = height
                                currentHeight = height
                            }
                    }
                    
                    
                    
                }, header: {
                    HeaderLabel(
                        title: "직군",
                        isRequired: false,
                        font: .pretendard14(.medium),
                        headerColor: .gray60
                    )
                }, footer: {
                    
                }, headerBottomPadding: 4, footerTopPadding: 0)
                
            }
            
            
        }
        .zIndex(-Double(history.id))
        .padding(.horizontal, 20)
        
    }
    
    private var dropDownSheet: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(sheetData, id: \.hashValue) { value in
                ZStack {
                    Text(value.rawValue)
                        .font(.pretendard16(.regular))
                        .foregroundStyle(.labelGray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                    
                    if history.position == value {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.gray08)
                    }
                }
                .contentShape(RoundedRectangle(cornerRadius: 8))
                .onTapGesture(perform: {
                    print("\(value.rawValue)")
                    history.position = value
                    withAnimation(globalAnimation) {
                        isSelected.toggle()
                    }
                })
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white)
                    
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray22, lineWidth: 1)
            }
        }
    }
    
    private func clickUpdate() {
        withAnimation(.smooth(duration: 0.5)) {
            if isSelected {
                overlayHeight = currentHeight
            } else {
                overlayHeight = 0
            }
        }
        rotateDegrees += 180
    }
}



#Preview {
    HistoryCell(history: .constant(.init(id: 1, old: false)), overlayHeight: .constant(20))
}
