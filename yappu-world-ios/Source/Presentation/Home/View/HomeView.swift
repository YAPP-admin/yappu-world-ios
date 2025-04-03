//
//  HomeView.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/6/25.
//

import SwiftUI

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
            .padding(.horizontal, 20)
            
            ScrollView {
                VStack(spacing: 16) {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12).foregroundStyle(.white)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(viewModel.profile?.name ?? "Yapp")
                                    .font(.pretendard28(.bold))
                                memberBadge(member: .convert(viewModel.profile?.role ?? "활동회원"))
                            }
                            let unit = viewModel.profile?.activityUnits.last
                            HStack(spacing: 4) {
                                Text("\(unit?.generation ?? 26)기")
                                    .setYPSkeletion(isLoading: viewModel.isLoading)
                                Text("∙")
                                    .offset(x: 0, y: -2.5)
                                
                                if let role = Position.convert(unit?.position.label ?? "DESIGN") {
                                    Text("\(role.rawValue)")
                                        .setYPSkeletion(isLoading: viewModel.isLoading)
                                }
                            }
                            .font(.pretendard14(.medium))
                            .foregroundStyle(Color.gray30)
                        }
                        .padding(.all, 16)
                        
                    }
                    .padding(.top, 16)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.white)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("공지사항")
                                    .font(.pretendard18(.semibold))
                            }
                            
                            VStack {
                                ForEach(0..<viewModel.noticeList.count, id: \.self) { idx in
                                    NoticeCell(notice: viewModel.noticeList[idx], isLoading: viewModel.isLoading)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            let data = viewModel.noticeList[idx]
                                            viewModel.clickNoticeDetail(id: data.id)
                                        }
                                    
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
                .padding(.horizontal, 20)
            }
        }
        .background(Color.mainBackgroundNormal.ignoresSafeArea())
        .task {
            do {
                try await viewModel.onAppear()
            } catch {
                print("error", error.localizedDescription)
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
