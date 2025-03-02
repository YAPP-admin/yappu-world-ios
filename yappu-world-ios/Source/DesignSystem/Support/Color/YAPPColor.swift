//
//  YAPPColor.swift
//  yappu-world-ios
//
//  Created by 김도형 on 2/14/25.
//

import SwiftUI

enum YAPPColor {
    case semantic(Semantic)
    
    var color: Color {
        switch self {
        case .semantic(let semantic): return semantic.color
        }
    }
}

extension YAPPColor {
    enum Semantic {
        case primary(Primary)
        case secondary(Secondary)
        case label(Label)
        case background(Background)
        case interaction(Interaction)
        case line(Line)
        case status(Status)
        case accent(Accent)
        case inverse(Inverse)
        case `static`(Static)
        
        var color: Color {
            switch self {
            case .primary(let primary): return primary.color
            case .secondary(let secondary): return secondary.color
            case .label(let label): return label.color
            case .background(let background): return background.color
            case .interaction(let interaction): return interaction.color
            case .line(let line): return line.color
            case .status(let status): return status.color
            case .accent(let accent): return accent.color
            case .inverse(let inverse): return inverse.color
            case .static(let `static`): return `static`.color
            }
        }
    }
}

extension YAPPColor.Semantic {
    enum Primary {
        case normal
        case strong
        case heavy
        
        var color: Color {
            switch self {
            case .normal: return .primaryNormal
            case .strong: return .primaryStrong
            case .heavy: return .primaryHeavy
            }
        }
    }
    
    enum Secondary {
        case normal
        case strong
        case heavy
        
        var color: Color {
            switch self {
            case .normal: return .secondaryNomal
            case .strong: return .secondaryStrong
            case .heavy: return .secondaryHeavy
            }
        }
    }
    
    enum Label {
        case normal
        case strong
        case neutral
        case alternative
        case assistive
        case disable
        
        var color: Color {
            switch self {
            case .normal: return .labelNormal
            case .strong: return .labelStrong
            case .neutral: return .labelNeutral
            case .alternative: return .labelAlternative
            case .assistive: return .labelAssistive
            case .disable: return .labelDisable
            }
        }
    }
    
    enum Background {
        case normal(Normal)
        case elevated(Elevated)
        
        enum Normal {
            case normal
            case alternative
            
            var color: Color {
                switch self {
                case .normal: return .backgroundNormal
                case .alternative: return .backgroundNormalAlternative
                }
            }
        }
        
        enum Elevated {
            case normal
            case alternative
            
            var color: Color {
                switch self {
                case .normal: return .backgroundElevatedNormal
                case .alternative: return .backgroundElvatedAlternative
                }
            }
        }
        
        var color: Color {
            switch self {
            case .normal(let normal): return normal.color
            case .elevated(let elevated): return elevated.color
            }
        }
    }
    
    enum Interaction {
        case inactive
        case disable
        
        var color: Color {
            switch self {
            case .inactive: return .interactionInactive
            case .disable: return .interactionDisable
            }
        }
    }
    
    enum Line {
        case normal
        case neutral
        case alternative
        
        var color: Color {
            switch self {
            case .normal: return .lineNormal
            case .neutral: return .lineNormalNeutral
            case .alternative: return .lineNormalAlternative
            }
        }
    }
    
    enum Status {
        case positive
        case cautionary
        case destructive
        
        var color: Color {
            switch self {
            case .positive: return .statusPositive
            case .cautionary: return .statusCautionary
            case .destructive: return .statusNegative
            }
        }
    }
    
    enum Accent {
        case redOrange
        case lime
        case cyan
        case lightBlue
        case violet
        case purple
        case pink
        
        var color: Color {
            switch self {
            case .redOrange: return .accentRedOrange
            case .lime: return .accentLime
            case .cyan: return .accentCyan
            case .lightBlue: return .accentLightBlue
            case .violet: return .accentViolet
            case .purple: return .accentPurple
            case .pink: return .accentPink
            }
        }
    }
    
    enum Inverse {
        case primary
        case background
        case label
        
        var color: Color {
            switch self {
            case .primary: return .inversePrimary
            case .background: return .inverseBackground
            case .label: return .inverseLabel
            }
        }
    }
    
    enum Static {
        case white
        case black
        
        var color: Color {
            switch self {
            case .white: return .staticWhite
            case .black: return .staticBlack
            }
        }
    }
}

