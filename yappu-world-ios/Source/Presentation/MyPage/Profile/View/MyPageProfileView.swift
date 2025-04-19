//
//  MyPageProfileView.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/16/25.
//

import SwiftUI

struct MyPageProfileView: View {

    @State
    var viewModel: MyPageViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 16) {
                Image("Profile")
                
                VStack(spacing: 6) {
                    HStack(spacing: 8) {
                        Text(viewModel.profile?.name ?? "Yapp")
                            .font(.pretendard18(.semibold))
                        memberBadge(member: .convert(viewModel.profile?.role ?? "활동회원"))
                        Spacer()
                    }
                    .setYPSkeletion(isLoading: viewModel.isLoading)

                    let unit = viewModel.profile?.activityUnits.last
                    HStack(spacing: 5) {
                        Text("\(unit?.generation ?? 26)기")
                            .setYPSkeletion(isLoading: viewModel.isLoading)
                        Text("∙")
                            .offset(x: 0, y: -2.5)
                        
                        if let role = Position.convert(unit?.position.label ?? "DESIGN") {
                            Text("\(role.rawValue)")
                                .setYPSkeletion(isLoading: viewModel.isLoading)
                        }
                        Spacer()
                    }
                    .font(.pretendard16(.regular))
                    .foregroundStyle(Color.gray60)
                }
            }
        }
        .padding(20)
    }
}
// MARK: - Private UI Builders
extension MyPageProfileView {
    
    private func memberBadge(member: Member) -> some View {
        Text(member.description)
            .font(.pretendard13(.medium))
            .foregroundStyle(member.color)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(member.color.opacity(0.10))
            )
            .fixedSize()
    }
}

#Preview {
    MyPageProfileView(viewModel: MyPageViewModel())
}
