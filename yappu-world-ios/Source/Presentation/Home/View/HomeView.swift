//
//  HomeView.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/6/25.
//

import SwiftUI

enum Member {
    
    /*
     
     관리자 = Admin
     운영진 = Staff
        
     활동회원 = Active
     정회원 = Associate
     수료회원 = Certified
     
     */
    
    case Admin
    case Staff
    case Active
    case Associate
    case Certified
    
    var color: Color {
        switch self {
        case .Admin:
            return .adminGray
        case .Staff:
            return .adminGray
        case .Active:
            return .activeMemberColor
        case .Associate:
            return .certifiedMemberColor
        case .Certified:
            return .certifiedMemberColor
        }
    }
    
    var description: String {
        switch self {
        case .Admin: "관리자"
        case .Staff: "운영진"
        case .Active: "활동회원"
        case .Associate: "정회원"
        case .Certified: "수료회원"
        }
    }
    
    static func convert(_ value: String) -> Self {
        switch value {
        case "관리자": .Admin
        case "운영진": .Staff
        case "활동회원": .Active
        case "정회원": .Associate
        case "수료회원": .Certified
        default: .Active
        }
    }
}

struct HomeView: View {
    
    @State
    var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image("yapp_logo")
                Spacer()
                
                Button(action: {
                    viewModel.clickSetting()
                }, label: {
                    Image("setting_icon")
                })
            }
            
            
            ScrollView {
                VStack(spacing: 16) {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12).foregroundStyle(.white)
                        
                        VStack(alignment: .leading) {
                            if let profile = viewModel.profile {
                                HStack {
                                    Text(profile.name)
                                        .font(.pretendard28(.bold))
                                    memberBadge(member: .convert(profile.role))
                                }
                                if let unit = profile.activityUnits.last {
                                    HStack(spacing: 4) {
                                        Text("\(unit.generation)기")
                                        Text("∙")
                                            .offset(x: 0, y: -2.5)
                                        if let role = Position.convert(unit.position) {
                                            Text("\(role.rawValue)")
                                        }
                                    }
                                    .font(.pretendard14(.medium))
                                    .foregroundStyle(Color.gray30)
                                }
                                
                            }
                        }
                        .padding(.all, 16)
                        
                    }
                    .padding(.top, 16)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12)    .foregroundStyle(.white)
                        VStack(alignment: .leading) {
                            HStack {
                               Text("공지사항")
                                    .font(.pretendard18(.semibold))
                            }
                            
                            VStack {
                                ForEach(0...2, id: \.self) { idx in
                                    NoticeCell(notice: .dummy())
                                    
                                    if idx != 2 {
                                        Divider()
                                            .padding(.vertical, 4.5)
                                            .opacity(0.5)
                                    }
                                }
                                
                                Button(action: {
                                    viewModel.clickNoticeList()
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 9)
                                            .strokeBorder(Color.gray22, lineWidth: 1)
                                        Text("더보기")
                                            .foregroundStyle(Color.labelGray)
                                            .font(.pretendard15(.regular))
                                            .padding(.vertical, 9)
                                    }
                                    .fixedSize(horizontal: false, vertical: true)
                                    .contentShape(Rectangle())
                                })
                                .padding(.top, 9)
                            }
                        }
                        .padding(.all, 16)
                    }
                }
                
            }
        }
        .padding(.horizontal, 20)
        .background(Color.mainBackgroundNormal.ignoresSafeArea())
        .onAppear {
            Task {
                try await viewModel.onAppear()
            }
        }
    }
}

extension HomeView {
    
    private func memberBadge(member: Member) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(member.color.opacity(0.10))
            
            Text(member.description)
                .font(.pretendard11(.medium))
                .foregroundStyle(member.color)
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
        }
        .fixedSize()
        .padding(.vertical, 9)
    }
}

#Preview {
    HomeView(viewModel: .init())
}
