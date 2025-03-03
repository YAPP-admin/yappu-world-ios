//
//  YPScrollView.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import SwiftUI

struct YPScrollView<Content: View> : View {
    
    private var axis: Axis.Set
    private var showsIndicators: Bool
    private var content: () -> Content
    private var ignoreSafeArea: Edge.Set
    
    @State private var offset: CGFloat = 0
    @State private var contentSize: CGFloat = .zero
    
    private var bottomOffset: CGFloat {
        let bottomSafeArea = ignoreSafeArea.contains(.bottom) ? 0 : UIApplication.shared.safeAreaInsets.bottom
        return contentSize + offset + UIApplication.shared.safeAreaInsets.top + bottomSafeArea
    }
    
    init(axis: Axis.Set = .vertical,
         showsIndicators: Bool = true,
         ignoreSafeArea: Edge.Set = [],
         @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.ignoreSafeArea = ignoreSafeArea
        self.content = content
    }
    
    
    var body: some View {
        ScrollView(axis, showsIndicators: showsIndicators) {
            VStack {
                content()
                    .trackScrollMetrics(offset: $offset, contentSize: $contentSize)
            }
        }
        .coordinateSpace(name: "scrollView")
        .overlay {
            VStack {
                LinearGradient(gradient:
                                Gradient(
                                    colors: [Color.black.opacity(0),
                                             Color.white.opacity(offset > -15 ? (-offset) / 15 : 1)]),
                               startPoint: .bottom, endPoint: .top
                )
                .frame(height: 40)
                
                Spacer()
                
                LinearGradient(gradient:
                                Gradient(
                                    colors: [Color.black.opacity(0),
                                             Color.white.opacity(
                                                bottomOffset < 15 ? bottomOffset / 15 : 1
                                             ) ]),
                               startPoint: .top, endPoint: .bottom
                )
                .frame(height: 40)
            }
            .allowsHitTesting(false)
        }
        .clipShape(Rectangle()) // 스크롤뷰 내용이 SafeArea를 벗어나지 않도록 클리핑
        .edgesIgnoringSafeArea(ignoreSafeArea)
    }
}

#Preview {
    YPScrollView(ignoreSafeArea: [.bottom]) {
        LazyVStack(spacing: 9) {
            ForEach(0...100, id: \.self) { idx in
                NoticeCell(notice: .dummy())
            }
        }
    }
}

// 사용하기 쉽도록 View extension 추가
extension View {
    func trackScrollMetrics(
        coordinateSpace: String = "scrollView",
        offset: Binding<CGFloat>,
        contentSize: Binding<CGFloat>
    ) -> some View {
        modifier(ScrollMetricsTracker(
            coordinateSpace: coordinateSpace,
            contentSize: contentSize,
            offset: offset
        ))
    }
}


// ScrollOffset과 ContentSize를 저장할 PreferenceKey들
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ContentSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// ScrollView에서 offset을 트래킹하는 ViewModifier
struct ScrollMetricsTracker: ViewModifier {
    let coordinateSpace: String
    @Binding var contentSize: CGFloat
    @Binding var offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: proxy.frame(in: .named(coordinateSpace)).minY
                        )
                        .preference(
                            key: ContentSizePreferenceKey.self,
                            value: proxy.frame(in: .named(coordinateSpace)).height - UIScreen.main.bounds.height
                        )
                }
            )
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                offset = value
            }
            .onPreferenceChange(ContentSizePreferenceKey.self) { size in
                contentSize = size
            }
    }
}

extension UIApplication {
    var safeAreaInsets: UIEdgeInsets {
        guard let scene = connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            return .zero
        }
        return window.safeAreaInsets
    }
}
