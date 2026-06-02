//
//  TeamServiceResponse.swift
//  yappu-world-ios
//
//  Created by 김도형 on 6/2/26.
//

import Foundation

// MARK: - 목록 (GET /v1/team-services) — DefaultResponse<TeamServicePageDTO>로 래핑됨

struct TeamServicePageDTO: Decodable {
    let data: [TeamServiceListItemDTO]
    let lastCursor: String?
    let limit: Int
    let hasNext: Bool
}

struct TeamServiceListItemDTO: Decodable {
    let serviceId: String
    let generation: Int
    let serviceName: String?
    let hasApp: Bool
    let hasWeb: Bool
    let summary: String?
    let thumbnailImageUrl: String?
}

extension TeamServicePageDTO {
    func toEntity() -> TeamServicePage {
        TeamServicePage(
            services: data.map { $0.toEntity() },
            lastCursor: lastCursor,
            hasNext: hasNext
        )
    }
}

extension TeamServiceListItemDTO {
    func toEntity() -> TeamServiceEntity {
        TeamServiceEntity(
            id: serviceId,
            name: serviceName ?? "",
            generation: generation,
            platforms: TeamServicePlatform.from(hasApp: hasApp, hasWeb: hasWeb),
            tagline: summary ?? "",
            description: "",
            thumbnailURL: thumbnailImageUrl.flatMap { URL(string: $0) },
            links: [],
            teamMembers: []
        )
    }
}

// MARK: - 상세 (GET /v1/team-services/{serviceId}) — 래핑 없이 바로 반환됨

struct TeamServiceDetailResponse: Decodable {
    let serviceId: String
    let generation: Int
    let serviceName: String
    let hasApp: Bool
    let hasWeb: Bool
    let summary: String
    let description: String?
    let thumbnailImageUrl: String?
    let googlePlayLink: String?
    let appStoreLink: String?
    let webLink: String?
    let members: [TeamServiceMemberDTO]
}

struct TeamServiceMemberDTO: Decodable {
    let userId: String
    let activityUnitId: String
    let name: String
    let position: String
}

extension TeamServiceDetailResponse {
    func toEntity() -> TeamServiceEntity {
        TeamServiceEntity(
            id: serviceId,
            name: serviceName,
            generation: generation,
            platforms: TeamServicePlatform.from(hasApp: hasApp, hasWeb: hasWeb),
            tagline: summary,
            description: description ?? "",
            thumbnailURL: thumbnailImageUrl.flatMap { URL(string: $0) },
            links: TeamServiceLink.make(appStore: appStoreLink, playStore: googlePlayLink, web: webLink),
            teamMembers: members.compactMap { $0.toEntity() }
        )
    }
}

extension TeamServiceMemberDTO {
    /// position 라벨이 매핑되지 않으면 nil → 호출부에서 compactMap으로 제외
    func toEntity() -> TeamServiceTeamMember? {
        guard let position = Position.convertLabel(position) else { return nil }
        return TeamServiceTeamMember(id: userId, name: name, position: position)
    }
}

// MARK: - 공개 회원 프로필 (GET /v1/users/{userId}/profile) — DefaultResponse<UserPersonProfileResponse>로 래핑됨

struct UserPersonProfileResponse: Decodable {
    let userId: String
    let name: String
    let role: String
    let latestActivity: UserPersonLatestActivityResponse?
    let histories: [UserPersonHistoryResponse]
}

struct UserPersonLatestActivityResponse: Decodable {
    let generation: Int
    let position: String
}

struct UserPersonHistoryResponse: Decodable {
    let generation: Int
    let position: String
    let activityStartDate: String?
    let activityEndDate: String?
    let service: UserPersonHistoryServiceResponse?
}

struct UserPersonHistoryServiceResponse: Decodable {
    let serviceId: String
    let teamName: String
    let serviceName: String
    let summary: String
    let hasApp: Bool
    let hasWeb: Bool
    let googlePlayLink: String?
    let appStoreLink: String?
    let webLink: String?
    let thumbnailImageUrl: String?
}

extension UserPersonProfileResponse {
    func toEntity() -> MemberProfileEntity {
        MemberProfileEntity(
            id: userId,
            name: name,
            role: role,
            profileImageURL: nil,
            latestGeneration: latestActivity?.generation,
            latestPosition: latestActivity.flatMap { Position.convertLabel($0.position) },
            activities: histories.map { $0.toEntity() }
        )
    }
}

extension UserPersonHistoryResponse {
    func toEntity() -> MemberActivityEntity {
        let isOperation = (position == "운영진")
        return MemberActivityEntity(
            generation: generation,
            position: isOperation ? nil : Position.convertLabel(position),
            isOperation: isOperation,
            periodStart: TeamServiceDateFormatter.activityPeriod(activityStartDate),
            periodEnd: TeamServiceDateFormatter.activityPeriod(activityEndDate),
            service: service?.toEntity()
        )
    }
}

extension UserPersonHistoryServiceResponse {
    func toEntity() -> ServiceSnippet {
        ServiceSnippet(
            serviceId: serviceId,
            name: serviceName,
            teamName: teamName,
            description: summary,
            platforms: TeamServicePlatform.from(hasApp: hasApp, hasWeb: hasWeb)
        )
    }
}

// MARK: - 활동 기간 날짜 포맷 (yyyy-MM-dd → yy.MM.dd)

enum TeamServiceDateFormatter {
    private static let input: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let output: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yy.MM.dd"
        return formatter
    }()

    /// "yyyy-MM-dd" → "yy.MM.dd". nil·파싱 실패 시 빈 문자열.
    static func activityPeriod(_ raw: String?) -> String {
        guard let raw, let date = input.date(from: raw) else { return "" }
        return output.string(from: date)
    }
}
