//
//  YPScrollView.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import SwiftUI

struct YPScrollView<Content: View> : View {
    private let axis: Axis.Set
    private let showsIndicators: Bool
    private let content: () -> Content
    
    private var safeAreaInsets = Edge.Set()

    @State private var offset: CGFloat = 0
    @State private var contentSize: CGFloat = .zero

    init(axis: Axis.Set = .vertical,
         showsIndicators: Bool = true,
         @ViewBuilder content: @escaping () -> Content
    ) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.content = content
    }

    var body: some View {
        ScrollView(axis, showsIndicators: showsIndicators) {
            content()
                .trackScrollMetrics(offset: $offset, contentSize: $contentSize)
        }
        .coordinateSpace(name: "scrollView")
        .overlay {
            GeometryReader { geometry in
                let topSafeAreaInsets = geometry.safeAreaInsets.top
                let bottomSafeAreaInsets = geometry.safeAreaInsets.bottom
                let bottomOffset = contentSize + offset + topSafeAreaInsets + bottomSafeAreaInsets
                let local = geometry.frame(in: .local)

                let setTop = safeAreaInsets.contains(.top)
                let topThreshold = setTop ? topSafeAreaInsets : 15
                let topHeight = setTop ? topSafeAreaInsets + 40 : 40

                fadeGradient(
                    opacity: offset > -topThreshold ? (-offset) / topThreshold : 1,
                    startPoint: .bottom,
                    endPoint: .top,
                    isEnhanced: setTop
                )
                .frame(height: topHeight)
                .offset(y: local.minY)

                let setBottom = safeAreaInsets.contains(.bottom)
                let bottomThreshold = setBottom ? bottomSafeAreaInsets : 15
                let bottomHeight = setBottom ? bottomSafeAreaInsets + 40 : 40

                fadeGradient(
                    opacity: bottomOffset < bottomThreshold ? bottomOffset / bottomThreshold : 1,
                    startPoint: .top,
                    endPoint: .bottom,
                    isEnhanced: setBottom
                )
                .frame(height: bottomHeight)
                .offset(y: local.maxY - bottomHeight)
            }
            .ignoresSafeArea()
        }
    }
    
    func setSafeAreaInsets(_ insets: Edge.Set) -> Self {
        var new = self
        new.safeAreaInsets = insets
        return new
    }

    private func fadeGradient(
        opacity: CGFloat,
        startPoint: UnitPoint,
        endPoint: UnitPoint,
        isEnhanced: Bool = false
    ) -> some View {
        let finalOpacity = isEnhanced ? min(opacity * 5, 1.0) : opacity

        return LinearGradient(
            gradient: Gradient(
                stops: isEnhanced ? [
                    .init(color: .black.opacity(0), location: 0),
                    .init(color: .white.opacity(finalOpacity * 0.6), location: 0.15),
                    .init(color: .white.opacity(finalOpacity * 0.9), location: 0.4),
                    .init(color: .white.opacity(finalOpacity), location: 1)
                ] : [
                    .init(color: .black.opacity(0), location: 0),
                    .init(color: .white.opacity(finalOpacity), location: 1)
                ]
            ),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
}

struct YPListView<Content: View> : View {
    private let content: () -> Content
    
    private var safeAreaInsets = Edge.Set()

    @State private var offset: CGFloat = 0
    @State private var contentSize: CGFloat = .zero

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        List {
            content()
                .trackScrollMetrics(offset: $offset, contentSize: $contentSize)
        }
        .coordinateSpace(name: "scrollView")
        .overlay {
            GeometryReader { geometry in
                let topSafeAreaInsets = geometry.safeAreaInsets.top
                let bottomSafeAreaInsets = geometry.safeAreaInsets.bottom
                let bottomOffset = contentSize + offset + topSafeAreaInsets + bottomSafeAreaInsets
                let local = geometry.frame(in: .local)

                let setTop = safeAreaInsets.contains(.top)
                let topThreshold = setTop ? topSafeAreaInsets : 15
                let topHeight = setTop ? topSafeAreaInsets + 40 : 40

                fadeGradient(
                    opacity: offset > -topThreshold ? (-offset) / topThreshold : 1,
                    startPoint: .bottom,
                    endPoint: .top,
                    isEnhanced: setTop
                )
                .frame(height: topHeight)
                .offset(y: local.minY)

                let setBottom = safeAreaInsets.contains(.bottom)
                let bottomThreshold = setBottom ? bottomSafeAreaInsets : 15
                let bottomHeight = setBottom ? bottomSafeAreaInsets + 40 : 40

                fadeGradient(
                    opacity: bottomOffset < bottomThreshold ? bottomOffset / bottomThreshold : 1,
                    startPoint: .top,
                    endPoint: .bottom,
                    isEnhanced: setBottom
                )
                .frame(height: bottomHeight)
                .offset(y: local.maxY - bottomHeight)
            }
            .ignoresSafeArea()
        }
    }
    
    func setSafeAreaInsets(_ insets: Edge.Set) -> Self {
        var new = self
        new.safeAreaInsets = insets
        return new
    }

    private func fadeGradient(
        opacity: CGFloat,
        startPoint: UnitPoint,
        endPoint: UnitPoint,
        isEnhanced: Bool = false
    ) -> some View {
        let finalOpacity = isEnhanced ? min(opacity * 5, 1.0) : opacity

        return LinearGradient(
            gradient: Gradient(
                stops: isEnhanced ? [
                    .init(color: .black.opacity(0), location: 0),
                    .init(color: .white.opacity(finalOpacity * 0.6), location: 0.15),
                    .init(color: .white.opacity(finalOpacity * 0.9), location: 0.4),
                    .init(color: .white.opacity(finalOpacity), location: 1)
                ] : [
                    .init(color: .black.opacity(0), location: 0),
                    .init(color: .white.opacity(finalOpacity), location: 1)
                ]
            ),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
}

#Preview {
    YPScrollView {
        LazyVStack(spacing: 9) {
            ForEach(0...100, id: \.self) { idx in
                NoticeCell(notice: .dummy(), isLoading: false)
            }
        }
    }
}

// 사용하기 쉽도록 content: <#() -> _#> View extension 추가
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
                DispatchQueue.main.async {
                    if self.contentSize != size {
                        self.contentSize = size
                    }
                }
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
