//
//  AllScheduleView.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/19/25.
//

import SwiftUI

struct AllScheduleView: View {
    
    @State var viewModel: AllScheduleViewModel = .init()
    
    var body: some View {
        VStack {
            InformationLabel(title: "일정", titleFont: .pretendard24(.bold))
                .padding(.horizontal, 20)
            
            YPSection(sections: viewModel.sections, isSelected: $viewModel.isSelected, tintColor: Color.yapp(.semantic(.label(.normal))))
        }
    }
}

#Preview {
    AllScheduleView()
}
