//
//  GenerationSheetView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

struct GenerationSheetView: View {
    let generations: [GenerationEntity]
    @Binding var pending: GenerationEntity?
    let onCancel: () -> Void
    let onApply: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("기수를 선택해주세요")
                .font(.pretendard18(.semibold))
                .foregroundStyle(.labelGray)

            // 팝업이 .fixedSize(vertical:)로 감싸므로 List/maxHeight는 높이 0으로 collapse됨.
            // 항목 수에 맞춘 고정 높이(최대 240) ScrollView로 안정 렌더링 + 스크롤.
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(generations) { gen in
                        row(for: gen)
                    }
                }
            }
            .frame(height: min(CGFloat(generations.count) * 44, 240))

            HStack(spacing: 8) {
                Button(action: onCancel) {
                    Text("취소")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.yapp(style: .border(.assistive)))

                Button(action: onApply) {
                    Text("적용하기")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.yapp(style: .primary))
                .disabled(pending == nil)
            }
        }
    }

    @ViewBuilder
    private func row(for gen: GenerationEntity) -> some View {
        let isSelected = pending?.id == gen.id

        Button {
            pending = gen
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(isSelected ? .yapp(.semantic(.primary(.normal))) : .gray22)

                Text(gen.displayName)
                    .font(.pretendard16(.regular))
                    .foregroundStyle(isSelected ? .labelGray : .gray52)

                Spacer()
            }
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var pending: GenerationEntity? = GenerationEntity(number: 25)
    GenerationSheetView(
        generations: GenerationEntity.dummyList(),
        pending: $pending,
        onCancel: {},
        onApply: {}
    )
    .padding()
}
