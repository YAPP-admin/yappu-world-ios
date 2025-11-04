//
//  YPChip.swift
//  yappu-world-ios
//
//  Created by 김도형 on 10/11/25.
//

import SwiftUI

struct YPChip: View {
    private let text: String
    
    private var style: YPChip.Style = .fill
    private var color: YPChip.Color = .orange
    private var size: YPChip.Size = .small
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.pretendard11(.regular))
            .foregroundStyle(style.textColor(color))
            .padding(.vertical, size.vPadding)
            .padding(.horizontal, size.hPadding)
            .background(style.backgroundColor(color))
            .clipRectangle(size.radius)
    }
    
    func style(_ style: YPChip.Style) -> Self {
        var newSelf = self
        newSelf.style = style
        return newSelf
    }
    
    func color(_ color: YPChip.Color) -> Self {
        var newSelf = self
        newSelf.color = color
        return newSelf
    }
    
    func size(_ size: YPChip.Size) -> Self {
        var newSelf = self
        newSelf.size = size
        return newSelf
    }
}

extension YPChip {
    enum Style {
        case fill
        case weak
        
        func textColor(_ color: YPChip.Color) -> SwiftUI.Color {
            switch self {
            case .fill: .yapp(.semantic(.static(.white)))
            case .weak: color.value
            }
        }
        
        func backgroundColor(_ color: YPChip.Color) -> SwiftUI.Color {
            switch self {
            case .fill: color.value
            case .weak: color.weak
            }
        }
    }
    
    enum Color {
        case red
        case orange
        case yellow
        case neutral
        case coolNeutral
        case lime
        case violet
        case blue
        case lightBlue
        case pink
        
        var value: SwiftUI.Color {
            switch self {
            case .red: .yapp(.semantic(.accent(.red)))
            case .orange: .yapp(.semantic(.primary(.normal)))
            case .yellow: .yapp(.semantic(.accent(.yellow)))
            case .neutral: .yapp(.primitive(.neutral30))
            case .coolNeutral: .yapp(.primitive(.coolNeutral))
            case .lime: .yapp(.semantic(.accent(.lime)))
            case .violet: .yapp(.semantic(.accent(.violet)))
            case .blue: .yapp(.semantic(.accent(.blue)))
            case .lightBlue: .yapp(.semantic(.accent(.lightBlue)))
            case .pink: .yapp(.semantic(.accent(.pink)))
            }
        }
        
        var weak: SwiftUI.Color {
            switch self {
            case .red: .yapp(.semantic(.accent(.redWeak)))
            case .orange: .yapp(.primitive(.orange95))
            case .yellow: .yapp(.primitive(.yellow95))
            case .neutral: .yapp(.primitive(.neutral95))
            case .coolNeutral: .yapp(.semantic(.fill(.alternative)))
            case .lime: .yapp(.semantic(.accent(.limeWeak)))
            case .violet: .yapp(.semantic(.accent(.violetWeak)))
            case .blue: .yapp(.semantic(.accent(.blueWeak)))
            case .lightBlue: .yapp(.semantic(.accent(.lightBlueWeak)))
            case .pink: .yapp(.semantic(.accent(.pinkWeak)))
            }
        }
    }
    
    enum Size {
        case small
        case large
        
        var vPadding: CGFloat {
            switch self {
            case .small: return 2
            case .large: return 3
            }
        }
        
        var hPadding: CGFloat {
            switch self {
            case .small: return 8
            case .large: return 10
            }
        }
        
        var radius: CGFloat {
            switch self {
            case .small: return 6
            case .large: return 8
            }
        }
    }
}

#Preview {
    HStack {
        YPChip("chip")
        
        YPChip("chip")
            .style(.weak)
        
        YPChip("chip")
            .size(.large)
        
        YPChip("chip")
            .style(.weak)
            .size(.large)
    }
    
    HStack {
        YPChip("chip")
            .color(.pink)
        
        YPChip("chip")
            .color(.pink)
            .style(.weak)
        
        YPChip("chip")
            .color(.pink)
            .size(.large)
        
        YPChip("chip")
            .color(.pink)
            .style(.weak)
            .size(.large)
    }
}
