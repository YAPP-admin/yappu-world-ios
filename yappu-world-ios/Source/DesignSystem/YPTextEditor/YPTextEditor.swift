//
//  YPTextEditor.swift
//  yappu-world-ios
//
//  Created by Tabber on 4/8/25.
//

import SwiftUI

enum YPTextEditorState {
    case `default`
    case active
    case success
}

/// YPTextEditor
/// state: 입력 상태 (default, active, success)
/// essential: 타이틀 필수표시 Bool (false,true)
/// title: 상단 타이틀 (Optional)
/// letterCount: 글자 카운트 여부 (Int) [기본값 : nil | nil일 경우 보이지 않습니다]
struct YPTextEditor: View {
    
    @Binding var state: YPTextEditorState
    @Binding var text: String
    
    private var essential: Bool
    private var title: String?
    private var titleFont: Pretendard.Style
    private var letterCount: Int?
    
    init(state: Binding<YPTextEditorState>, text: Binding<String>, essential: Bool, title: String? = nil, titleFont: Pretendard.Style = .pretendard14(.regular), letterCount: Int? = nil) {
        self._state = state
        self._text = text
        self.essential = essential
        self.title = title
        self.titleFont = titleFont
        self.letterCount = letterCount
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            if let title {
                Text(title)
                    .font(titleFont)
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))
            }
            
            TextEditor(text: $text)
                .textEditorStyle(.yapp(state: $state))
        }
    }
}



#Preview {

    @Previewable @State var state: YPTextEditorState = .default
    @Previewable @State var text: String = ""
    
    YPTextEditor(state: $state, text: $text, essential: true, title: "제목")
}
