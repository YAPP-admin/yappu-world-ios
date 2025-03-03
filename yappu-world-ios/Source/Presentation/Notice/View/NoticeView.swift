//
//  NoticeView.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/16/25.
//

import SwiftUI

struct NoticeView: View {
    
    @State var viewModel: NoticeViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Group {
                InformationLabel(title: "공지사항", titleFont: .pretendard24(.bold))
                HStack {
                    NoticeTypeSelector(selectedType: $viewModel.selectedNoticeList)
                    
                    Spacer()
                    
                    if viewModel.currentUserRole == .Admin {
                        Button(action: {
                            viewModel.openBottomPopup()
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .strokeBorder(Color.yapp(.semantic(.line(.normal))), lineWidth: 1)
                                HStack {
                                    Text("\(viewModel.noticeDisplayTargetText())")
                                        .font(.pretendard13(.regular))
                                        .foregroundStyle(.yapp(.semantic(.label(.normal))))
                                    Image("control_Icon")
                                }
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                            }
                            .fixedSize()
                        })
                        
                    }
                }
                
            }
            .padding(.horizontal, 20)
            
            YPScrollView {
                
                LazyVStack(spacing: 9) {
                    
                    Spacer()
                        .padding(.top, 16)
                    
                    ForEach(viewModel.notices, id: \.id) { notice in
                        NoticeCell(notice: notice)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.clickNoticeDetail(id: notice.id)
                            }
                        YPDivider(color: .gray08)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .padding(.bottom, 16)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            Task {
                try await viewModel.loadNotices()
            }
        }
        .backButton(title: "공지사항", action: viewModel.clickBackButton)
        .yappBottomPopup(isOpen: $viewModel.bottomPopupIsOpen, view: {
            VStack(alignment: .leading, spacing: 0) {
                Text("필터")
                    .font(.pretendard18(.semibold))
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))
                
                Text("노출 대상")
                    .font(.pretendard14(.semibold))
                    .foregroundStyle(.yapp(.semantic(.label(.normal))))
                    .padding(.top, 24)
                
                let types: [DisplayTargetType] = [.All, .Certificated, .Player]
                
                HStack(spacing: 8) {
                    ForEach(types, id:\.self) { type in
                        ZStack {
                            
                            let isSelected = viewModel.preSelectedNoticeDisplayTargets.contains(type)
                            
                            RoundedRectangle(cornerRadius: 14)
                                .if(isSelected.not()) {
                                    $0.strokeBorder(Color.yapp(.semantic(.primary(.normal))), lineWidth: 1)
                                }
                                .foregroundStyle(.yapp(.semantic(.primary(.normal))))
                           
                            Text(type.text)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 5)
                                .foregroundStyle(isSelected ? .white : .yapp(.semantic(.primary(.normal))))
                                .font(.pretendard13(.semibold))
                        }
                        .contentShape(RoundedRectangle(cornerRadius: 14))
                        .fixedSize()
                        .onTapGesture {
                            viewModel.controlDisplayTarget(type)
                        }
                    }
                }
                .padding(.top, 8)
                
                Button(action: {
                    viewModel.applyDisplayTarget()
                }, label: {
                    Text("적용")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.yapp(style: .primary))
                .padding(.top, 24)
            }
        })
    }
}

#Preview {
    NoticeView(viewModel: .init())
}
