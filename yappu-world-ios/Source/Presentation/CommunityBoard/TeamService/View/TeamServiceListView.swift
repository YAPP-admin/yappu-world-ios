//
//  TeamServiceListView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import SwiftUI

struct TeamServiceListView: View {
    @Bindable
    var viewModel: TeamServiceListViewModel

    private let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            filterRow
                .padding(.horizontal, 20)
                .padding(.top, 12)

            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: 20) {
                    ForEach(viewModel.services) { service in
                        let isLast = viewModel.services.last?.id == service.id

                        Button {
                            viewModel.clickServiceCard(service.id)
                        } label: {
                            TeamServiceCard(service: service, isLoading: viewModel.isLoading)
                        }
                        .buttonStyle(.plain)
                        .if(isLast && viewModel.hasNext) { $0.task {
                            await viewModel.loadMore()
                        }}
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .refreshable(action: viewModel.listRefreshable)
        }
        .task(viewModel.listTask)
    }

    private var filterRow: some View {
        HStack {
            GenerationDropdown(
                title: viewModel.selectedGeneration.displayName,
                action: viewModel.clickGenerationDropdown
            )
            Spacer()
            TeamServicePlatformChipRow(selected: Binding(
                get: { viewModel.selectedPlatform },
                set: { viewModel.selectPlatform($0) }
            ))
        }
    }
}

#Preview {
    TeamServiceListView(viewModel: .init())
}
