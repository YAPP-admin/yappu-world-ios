//
//  PreActivitiesView.swift
//  yappu-world-ios
//
//  Created by 김건형 on 4/15/25.
//

import SwiftUI

struct PreActivitiesView: View {
    @State
    var viewModel: PreActivitiesViewModel
    
    var body: some View {
        YPScrollView(axis: .vertical,
                     showsIndicators: true,
                     ignoreSafeArea: [],
                     content: {
            LazyVStack(spacing: 12) {
                
                if viewModel.activities.isEmpty && viewModel.isLoading.not() {
                    Image("illust_member_home_disabled_notFound")
                        .padding(.top, 150)
                    Text("이전 활동내역이 없어요")
                        .font(.pretendard14(.regular))
                        .foregroundStyle(.yapp(.semantic(.label(.alternative))))
                } else {
                    Color.red
                        .frame(width: .infinity, height: 8000)
                }
            } // LazyVStack
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .ignoresSafeArea(edges: .bottom)
        })
        .backButton(title: "이전 활동내역", action: viewModel.clickBackButton)
        .task {
            do {
                try await viewModel.onTask()
            } catch {
                await viewModel.errorAction()
            }
        }
    }
}

#Preview {
    PreActivitiesPreviewWrapper()
}

private struct PreActivitiesPreviewWrapper: View {
    var body: some View {
        var viewModel = PreActivitiesViewModel()
        viewModel.activities = PreActivityEntity.dummyList()

        return PreActivitiesView(viewModel: viewModel)
    }
}
