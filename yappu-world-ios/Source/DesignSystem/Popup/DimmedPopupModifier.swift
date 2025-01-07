//
//  DimmedPopupModifier.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/7/25.
//

import SwiftUI

struct DimmedPopupModifier<Popup: View>: ViewModifier {
    @Binding var isOpen: Bool
    @ViewBuilder let popupView: Popup
    var horizontalPadding: CGFloat
    var verticalPadding: CGFloat
    var alignment: Alignment = .bottom
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isOpen = false // 팝업 닫기
                    }
            }
            
            VStack {
                switch alignment {
                case .bottom:
                    Spacer()
                default:
                    EmptyView()
                }
                
                if isOpen {
                    
                    ZStack(alignment: .leading) {
                        Color.white
                            .frame(maxWidth: .infinity)
                            .cornerRadius(radius: 16, corners: .allCorners)
                        
                        popupView
                            .transition(.move(edge: .bottom)) // 팝업 애니메이션 추가
                            .zIndex(1) // 팝업을 최상단으로 설정
                            .padding(.horizontal, horizontalPadding)
                            .padding(.vertical, verticalPadding)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 8)
                }
            }
            
        }
    }
}

extension View {
    func yappBottomPopup<Popup: View>(
        isOpen: Binding<Bool>,
        horizontalPadding: CGFloat = 20,
        verticalPadding: CGFloat = 20,
        @ViewBuilder view: @escaping () -> Popup
    ) -> some View {
        modifier(
            DimmedPopupModifier<Popup>(
                isOpen: isOpen,
                popupView: view,
                horizontalPadding: horizontalPadding,
                verticalPadding: verticalPadding,
                alignment: .bottom
            )
        )
    }
    
    func yappDefaultPopup<Popup: View>(
        isOpen: Binding<Bool>,
        horizontalPadding: CGFloat = 20,
        verticalPadding: CGFloat = 20,
        @ViewBuilder view: @escaping () -> Popup
    ) -> some View {
        modifier(
            DimmedPopupModifier<Popup>(
                isOpen: isOpen,
                popupView: view,
                horizontalPadding: horizontalPadding,
                verticalPadding: verticalPadding,
                alignment: .center
            )
        )
    }
}

#Preview {
    VStack {
        Text("Hello")
            .font(.title)
            .padding()
    }
    .yappBottomPopup(isOpen: .constant(true)) {
        VStack(alignment: .leading) {
            Text("서비스 이용약관")
                .font(.pretendard18(.bold))
                .foregroundStyle(Color.labelGray)
        }
    }
}
