//
//  YPStatusView.swift
//  yappu-world-ios
//
//  Created by Tabber on 3/30/25.
//

import SwiftUI

enum YPStatusViewType {
    case Failed
    case Success
}

struct YPStatusView: View {
    
    private var status: YPStatusViewType
    
    init(status: YPStatusViewType) {
        self.status = status
    }
    
    var body: some View {
        switch status {
        case .Failed:
            Image("_Icons_Responsive_Fail")
        case .Success:
            Image("_Icons_Responsive_Success")
        }
    }
}

#Preview {
    YPStatusView(status: .Failed)
}
