//
//  Position+TeamService.swift
//  yappu-world-ios
//
//  Created by 김도형 on 5/13/26.
//

import Foundation

extension Position {
    /// 역대서비스 상세에서 팀원 그룹 순서
    var displayOrder: Int {
        switch self {
        case .PM: 0
        case .UIUX_Design: 1
        case .iOS: 2
        case .Android: 3
        case .Server: 4
        case .Web: 5
        case .Flutter: 6
        case .Staff: 7
        }
    }

    /// 회원 프로필 활동 row의 직군 칩 색상 (현 커밋에서 미사용 가능성 있으나 호출처 보존을 위해 유지)
    var chipColor: YPChip.Color {
        switch self {
        case .PM: .orange
        case .UIUX_Design: .pink
        case .iOS: .blue
        case .Android: .lime
        case .Server: .violet
        case .Web: .coolNeutral
        case .Flutter: .lightBlue
        case .Staff: .neutral
        }
    }

    /// "Design" 같은 짧은 라벨 (Position의 rawValue는 "UXUI Design"이라 칩에 길어서 별도 라벨)
    var shortLabel: String {
        switch self {
        case .PM: "PM"
        case .UIUX_Design: "Design"
        case .iOS: "iOS"
        case .Android: "Android"
        case .Server: "Server"
        case .Web: "Web"
        case .Flutter: "Flutter"
        case .Staff: "Staff"
        }
    }
}

extension TeamServicePlatform {
    /// Figma 9158:3845 - App/Web 칩 모두 orange 계열, App=fill, Web=weak
    var chipColor: YPChip.Color { .orange }

    var chipStyle: YPChip.Style {
        switch self {
        case .app: .fill
        case .web: .weak
        }
    }
}
