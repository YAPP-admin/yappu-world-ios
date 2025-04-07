//
//  YPSwitch.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/8/25.
//

import SwiftUI

// 스위치 사이즈 enum
enum YPSwitchSize {
    case small
    case medium
}


/// YPSwitch
/// isOn : 데이터 바인딩 Bool
/// label: 토글에 대한 레이블 (Optional)
/// isDisabled: 비활성화 상태
/// size: 스위치 사이즈 (medium, small)
/// action : 토글 액션 async/await (Optional)
struct YPSwitch: View {
    @Binding var isOn: Bool
    private var label: String
    private var isDisabled: Bool
    private var size: YPSwitchSize
    private var action: (() async -> Void)?
    
    
    /// YPSwitch
    /// isOn : 데이터 바인딩 Bool
    /// label: 토글에 대한 레이블 (Optional)
    /// isDisabled: 비활성화 상태
    /// size: 스위치 사이즈 (medium, small)
    /// action : 토글 액션 async/await (Optional)
    init(
        isOn: Binding<Bool>,
        label: String = "",
        isDisabled: Bool = false,
        size: YPSwitchSize = .medium,
        action: (() async -> Void)? = nil
    ) {
        self._isOn = isOn
        self.label = label
        self.isDisabled = isDisabled
        self.size = size
        self.action = action
    }
    
    var body: some View {
        Toggle(label, isOn: Binding(
            get: { isOn },
            set: { newValue in
                isOn = newValue
                if let action = action {
                    Task {
                        await action()
                    }
                }
            }
        ))
        .tint(.yapp(.semantic(.primary(.normal))).ypOpacity(isDisabled ? .opacity_43 : .opacity_100))
        .toggleStyle(YPSwitchStyle(size: size, opacity: isDisabled ? .opacity_43 : .opacity_100))
        .disabled(isDisabled)
    }
}

struct YPSwitchStyle: ToggleStyle {
    let size: YPSwitchSize
    let opacity: YPOpacity
    
    private var switchWidth: CGFloat {
        return size == .small ? 39 : 52
    }
    
    private var switchHeight: CGFloat {
        return size == .small ? 24 : 32
    }
    
    // 썸(원형 핸들) 크기 및 오프셋 계산
    private var thumbDiameter: CGFloat {
        return size == .small ? 18 : 24
    }
    
    private var thumbOffset: CGFloat {
        let trackWidth = switchWidth
        let thumbWidth = thumbDiameter
        let movableDistance = (trackWidth - thumbWidth - 8) / 2
        return movableDistance
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            Spacer()
            
            ZStack {
                Capsule()
                    .fill(configuration.isOn
                          ? Color.yapp(.semantic(.primary(.normal))).ypOpacity(opacity)
                          : Color.gray.opacity(0.3)).ypOpacity(opacity)
                    .frame(width: switchWidth, height: switchHeight)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: thumbDiameter, height: thumbDiameter)
                    .offset(x: configuration.isOn ? thumbOffset : -thumbOffset)
                    .animation(.spring(response: 0.2), value: configuration.isOn)
            }
            .onTapGesture {
                withAnimation {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var isOn = true
    VStack(spacing: 10) {
        YPSwitch(isOn: $isOn, label: "", isDisabled: false, size: .medium, action: {
            
        })
        
        YPSwitch(isOn: $isOn, label: "", isDisabled: false, size: .small, action: {
            
        })
    }
    
}
