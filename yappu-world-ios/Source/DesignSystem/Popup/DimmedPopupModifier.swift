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
    var showBackground: Bool = true
    
    func body(content: Content) -> some View {
        content
            .overlay {
                Group {
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
                        
                        ZStack(alignment: .leading) {
                            if showBackground {
                                Color.white
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(radius: 16, corners: .allCorners)
                            }
                            
                            popupView
                                .transition(.move(edge: .bottom)) // 팝업 애니메이션 추가
                                .padding(.horizontal, horizontalPadding)
                                .padding(.vertical, verticalPadding)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 8)
                        .offset(x: 0, y: isOpen ? 0 : 15)
                        .opacity(isOpen ? 1 : 0)
                    }
                    
                }
                .animation(.smooth(duration: 0.2), value: isOpen) // 모든 애니메이션을 동기화
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
        showBackground: Bool = true,
        @ViewBuilder view: @escaping () -> Popup
    ) -> some View {
        modifier(
            DimmedPopupModifier<Popup>(
                isOpen: isOpen,
                popupView: view,
                horizontalPadding: horizontalPadding,
                verticalPadding: verticalPadding,
                alignment: .center,
                showBackground: showBackground
            )
        )
    }
}

#Preview {
    VStack {
        Spacer()
        
        HStack { Spacer() }
        Text("Hello")
            .font(.title)
            .padding()
        
        Spacer()
    }
    .yappDefaultPopup(isOpen: .constant(true)) {
        VStack(alignment: .leading) {
            Text("서비스 이용약관")
                .font(.pretendard18(.bold))
                .foregroundStyle(Color.labelGray)
        }
    }
}
