//
//  PastServiceListViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation
import Observation
import Dependencies
import DependenciesMacros

@Observable
final class PastServiceListViewModel {
    @ObservationIgnored
    @Dependency(Navigation<TabViewGlobalPath>.self)
    private var navigation

    @ObservationIgnored
    @Dependency(PastServiceUseCase.self)
    private var useCase

    var isLoading: Bool = true
    var allServices: [PastServiceEntity] = []
    var generations: [GenerationEntity] = GenerationEntity.dummyList()
    var selectedGeneration: GenerationEntity = .init(number: 25)
    var selectedPlatform: PastServicePlatform? = nil
    var isGenerationSheetOpen: Bool = false
    var pendingGenerationInSheet: GenerationEntity? = .init(number: 25)

    var filteredServices: [PastServiceEntity] {
        allServices
            .filter { $0.generation == selectedGeneration.number }
            .filter { service in
                guard let platform = selectedPlatform else { return true }
                return service.platforms.contains(platform)
            }
    }

    init() {}

    @Sendable
    func listTask() async {
        await load()
    }

    @Sendable
    func listRefreshable() async {
        await load()
    }

    private func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            allServices = try await useCase.loadServices()
        } catch {
            allServices = []
        }
    }

    // MARK: - 필터 액션

    func clickGenerationDropdown() {
        pendingGenerationInSheet = selectedGeneration
        isGenerationSheetOpen = true
    }

    func clickGenerationCancel() {
        isGenerationSheetOpen = false
    }

    func clickGenerationApply() {
        if let pending = pendingGenerationInSheet {
            selectedGeneration = pending
        }
        isGenerationSheetOpen = false
    }

    func selectPlatform(_ platform: PastServicePlatform?) {
        selectedPlatform = platform
    }

    // MARK: - 네비게이션

    func clickServiceCard(_ id: String) {
        navigation.push(.pastServiceDetail(id: id))
    }
}
