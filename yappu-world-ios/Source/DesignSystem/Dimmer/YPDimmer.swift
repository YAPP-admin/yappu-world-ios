//
//  YPDimmer.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/8/25.
//

import SwiftUI

enum YPDimmerVariant {
    case alert
    case sheet
    
    var alpha: YPOpacity {
        switch self {
        case .alert:
            return .opacity_52
        case .sheet:
            return .opacity_28
        }
    }
}

struct YPDimmer: View {
    private var variant: YPDimmerVariant
    
    init(variant: YPDimmerVariant) {
        self.variant = variant
    }
    
    var body: some View {
        Color.black
            .ypOpacity(variant.alpha)
            .ignoresSafeArea(edges: .all)
    }
}

#Preview {
    YPDimmer(variant: .alert)
}
