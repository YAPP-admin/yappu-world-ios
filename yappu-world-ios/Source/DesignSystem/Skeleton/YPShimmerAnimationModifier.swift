//
//  YPShimmerAnimationModifier.swift
//  yappu-world-ios
//
//  Created by 김건형 on 3/30/25.
//

import SwiftUI

//MARK: 반짝이는 스켈레톤 View
struct YPShimmerAnimationModifier: ViewModifier {
    //MARK: Property
    var isLoading: Bool                 // 스켈레톤 활성화
    var gradientColors: [Color] = [
        Color.loadingGray,
        Color.gray05,
        Color.loadingGray
    ]
    private var rightEdgeFadeMaskGradient: Gradient {
        Gradient(stops: [
            .init(color: .black, location: 0.0),
            .init(color: .black, location: 0.75),
            .init(color: .clear, location: 1.0)
        ])
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                shimmerOverlay
            }
            .animation(.easeInOut, value: isLoading)
    }

    private var shimmerOverlay: some View {
        ZStack {
            Color.white

            TimelineView(.animation(minimumInterval: 0.016, paused: !isLoading)) { timeline in
                let progress = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 1.5) / 1.5

                LinearGradient(
                    colors: gradientColors,
                    startPoint: UnitPoint(
                        x: -1 + progress * 2.5,
                        y: 0.5
                    ),
                    endPoint: UnitPoint(
                        x: 0 + progress * 2.5,
                        y: 0.5
                    )
                )
                .mask(
                    // 오른쪽 흐림 효과 마스크 적용
                    LinearGradient(
                        gradient: rightEdgeFadeMaskGradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            }
            .clipRectangle(15)
        }
        .opacity(isLoading ? 1 : 0)
    }
}

extension View {
    // View Extension을 통해 .modifier를 쓰지 않고 쓸수 있음
    func setYPSkeletion(isLoading: Bool) -> some View {
        self.modifier(YPShimmerAnimationModifier(isLoading: isLoading))
    }
}

#Preview {
    @Previewable @State var isLoading = true

    ZStack {
        VStack {
            Text("한반도의 경제 협력이 새로운 국면을 맞이하며 남북 간 첫 연합 기업이 설립되었습니다. 이 기업은 에너지, 통신, 제조 등 다양한 분야에서 남북 간 협력 모델을 제시하며 경제적 도약을 목표로 하고 있습니다. 특히, 이번 연합 기업은 지속 가능한 발전을 위한 친환경 기술과 공동 연구 개발을 핵심 과제로 삼고 있으며, 이를 통해 글로벌 시장에서도 경쟁력을 확보하고자 합니다. 전문가들은 이러한 경제 협력이 한반도뿐만 아니라 동아시아 전체의 경제적 안정과 성장에도 기여할 것으로 예상하고 있습니다.")
                .setYPSkeletion(isLoading: isLoading)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                        isLoading = false
                    })
                }
        }
        .padding(.horizontal)
    }
}
