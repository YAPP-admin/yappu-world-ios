//
//  PastServiceListView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

struct PastServiceListView: View {
    @Bindable
    var viewModel: PastServiceListViewModel

    private let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            filterRow
                .padding(.horizontal, 20)
                .padding(.top, 12)

            Text(viewModel.subtitleText)
                .font(.pretendard14(.medium))
                .foregroundStyle(.labelGray)
                .padding(.horizontal, 20)

            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: 20) {
                    ForEach(viewModel.filteredServices) { service in
                        Button {
                            viewModel.clickServiceCard(service.id)
                        } label: {
                            PastServiceCard(service: service, isLoading: viewModel.isLoading)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .refreshable(action: viewModel.listRefreshable)
        }
        .task(viewModel.listTask)
        .yappBottomPopup(isOpen: $viewModel.isGenerationSheetOpen) {
            GenerationSheetView(
                generations: viewModel.generations,
                pending: $viewModel.pendingGenerationInSheet,
                onCancel: viewModel.clickGenerationCancel,
                onApply: viewModel.clickGenerationApply
            )
        }
    }

    private var filterRow: some View {
        HStack {
            GenerationDropdown(
                title: viewModel.selectedGeneration.displayName,
                action: viewModel.clickGenerationDropdown
            )
            Spacer()
            PastServicePlatformChipRow(selected: Binding(
                get: { viewModel.selectedPlatform },
                set: { viewModel.selectPlatform($0) }
            ))
        }
    }
}

#Preview {
    PastServiceListView(viewModel: .init())
}
