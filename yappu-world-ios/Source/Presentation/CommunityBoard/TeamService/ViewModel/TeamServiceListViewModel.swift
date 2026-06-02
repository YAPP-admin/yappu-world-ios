//
//  TeamServiceListViewModel.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation
import Observation
import Dependencies

@Observable
final class TeamServiceListViewModel {
    @ObservationIgnored
    @Dependency(Navigation<TabViewGlobalPath>.self)
    private var navigation

    @ObservationIgnored
    @Dependency(TeamServiceUseCase.self)
    private var useCase

    @ObservationIgnored
    private var lastCursorId: String? = nil

    @ObservationIgnored
    private var firstAppear = false

    @ObservationIgnored
    private var isFetching = false

    private let pageSize = 20

    var isLoading: Bool = true
    var hasNext: Bool = false
    var services: [TeamServiceEntity] = []
    // 전체 기수 목록 API 부재 → 더미(최신 27기까지). API 합류 시 교체.
    var generations: [GenerationEntity] = GenerationEntity.dummyList(latest: 27)
    var selectedGeneration: GenerationEntity = .init(number: 27)
    var selectedPlatform: TeamServicePlatform? = nil
    var isGenerationSheetOpen: Bool = false
    var pendingGenerationInSheet: GenerationEntity? = .init(number: 27)

    init() {}

    // MARK: - 로딩 (커서 페이지네이션)

    @Sendable
    func listTask() async {
        guard !firstAppear else { return }
        firstAppear = true
        await reload()
    }

    @Sendable
    func listRefreshable() async {
        await reload()
    }

    func loadMore() async {
        guard hasNext else { return }
        await load()
    }

    /// 첫 페이지부터 다시 로드 (기수/플랫폼 변경, 당겨서 새로고침)
    private func reload() async {
        lastCursorId = nil
        hasNext = false
        services = []
        isLoading = true
        await load()
    }

    private func load() async {
        guard !isFetching else { return }
        isFetching = true
        defer {
            isFetching = false
            isLoading = false
        }
        do {
            let page = try await useCase.loadServices(
                lastCursorId,
                pageSize,
                selectedGeneration.number,
                selectedPlatform
            )
            if lastCursorId == nil {
                services = page.services
            } else {
                services.append(contentsOf: page.services)
            }
            lastCursorId = page.lastCursor
            hasNext = page.hasNext
        } catch {
            if lastCursorId == nil { services = [] }
            hasNext = false
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
        isGenerationSheetOpen = false
        guard let pending = pendingGenerationInSheet, pending != selectedGeneration else { return }
        selectedGeneration = pending
        Task { await reload() }
    }

    func selectPlatform(_ platform: TeamServicePlatform?) {
        guard platform != selectedPlatform else { return }
        selectedPlatform = platform
        Task { await reload() }
    }

    // MARK: - 네비게이션

    func clickServiceCard(_ id: String) {
        navigation.push(.teamServiceDetail(id: id))
    }
}
