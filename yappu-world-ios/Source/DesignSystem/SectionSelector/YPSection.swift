//
//  YPSection.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/14/25.
//

import SwiftUI

enum YPSectionType: Hashable {
    case notice
    case community
}

struct YPSectionEntity: Hashable, Equatable {
    var id: YPSectionType
    var title: String
}

struct YPSection: View {
    
    var sections: [YPSectionEntity] = []
    @Binding var isSelected: YPSectionType
    @Namespace var namespace
    
    init(sections: [YPSectionEntity], isSelected: Binding<YPSectionType>) {
        self.sections = sections
        self._isSelected = isSelected
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 16) {
                ForEach(sections, id: \.id) { section in
                    VStack(spacing: 4) {
                        Text(section.title)
                            .padding(.horizontal, 4)
                            .font(.pretendard18(isSelected == section.id ? .semibold : .medium))
                            .foregroundStyle(isSelected == section.id ? .yapp(.semantic(.label(.normal))) : .yapp(.semantic(.label(.assistive))))
                        
                        if isSelected == section.id {
                            YPDivider(color: .yapp(.semantic(.primary(.normal))))
                                .matchedGeometryEffect(id: "selected", in: namespace)
                        } else {
                            YPDivider(color: .clear)
                        }
                    }
                    .fixedSize()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            isSelected = section.id
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.leading, 20)
            
            YPDivider(color: .yapp(.semantic(.line(.alternative))))
        }
    }
}

#Preview {
    
    @Previewable @State var data: [YPSectionEntity] = [.init(id: .notice, title: "공지사항"),
                                                       .init(id: .community, title: "자유게시판")]
    @Previewable @State var isSelected: YPSectionType = .community
    
    YPSection(sections: data, isSelected: $isSelected)
}
